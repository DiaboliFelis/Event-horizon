//Список гостей
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestsPage extends StatelessWidget {
  final String documentId;
  final List<String> attendingUsers;

  const GuestsPage({
    Key? key,
    required this.documentId,
    required this.attendingUsers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GuestListScreen(
      documentId: documentId,
      initialAttendingUsers: attendingUsers,
    );
  }
}

class GuestListScreen extends StatefulWidget {
  final String documentId;
  final List<String> initialAttendingUsers;

  const GuestListScreen({
    Key? key,
    required this.documentId,
    required this.initialAttendingUsers,
  }) : super(key: key);

  @override
  GuestListScreenState createState() => GuestListScreenState();
}

class GuestListScreenState extends State<GuestListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String currentUserId = '';
  List<String> guests = [];

  @override
  void initState() {
    super.initState();
    _loadGuestsFromSharedPreferences();
    _getCurrentUserId();
  }

  // Загрузка списка гостей из SharedPreferences
  Future<void> _loadGuestsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      guests = prefs.getStringList('guests_${widget.documentId}') ??
          widget.initialAttendingUsers;
    });
  }

  // Сохранение списка гостей в SharedPreferences
  Future<void> _saveGuestsToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('guests_${widget.documentId}', guests);
  }

  void _getCurrentUserId() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  // Получение логина пользователя по ID
  Future<String> _getUserLogin(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data()?['name'] as String? ?? 'Без логина';
      } else {
        return 'Пользователь не найден';
      }
    } catch (e) {
      return 'Ошибка загрузки';
    }
  }

  Future<void> _addGuestByLogin(String login) async {
    if (login.isEmpty) return;

    try {
      final query = await _firestore
          .collection('users')
          .where('login', isEqualTo: login)
          .get();

      if (query.docs.isEmpty) {
        _showErrorDialog('Пользователь с таким логином не найден');
        return;
      }

      final guestUserId = query.docs.first.id;

      if (guestUserId == currentUserId) {
        _showErrorDialog('Нельзя добавить самого себя');
        return;
      }

      if (guests.contains(guestUserId)) {
        _showErrorDialog('Этот пользователь уже в списке гостей');
        return;
      }

      // Добавляем пользователя в подколлекцию мероприятия
      await _firestore
          .collection('events')
          .doc(widget.documentId)
          .collection('attendingUsers')
          .doc(guestUserId)
          .set({'addedAt': FieldValue.serverTimestamp()});

      print('Добавляем гостя в мероприятие с ID: ${widget.documentId}');

      await _firestore.collection('events').doc(widget.documentId).update({
        'attendingUsers': FieldValue.arrayUnion([guestUserId]),
      });

      setState(() {
        guests.add(guestUserId);
      });

      await _saveGuestsToSharedPreferences();
    } catch (e) {
      _showErrorDialog('Ошибка при добавлении гостя: ${e.toString()}');
    }
  }

  Future<void> _removeGuest(String userId) async {
    // Удаляем пользователя из подколлекции мероприятия
    await _firestore
        .collection('events')
        .doc(widget.documentId)
        .collection('attendingUsers')
        .doc(userId)
        .delete();

    await _firestore.collection('events').doc(widget.documentId).update({
      'attendingUsers': FieldValue.arrayRemove([userId]),
    });

    setState(() {
      guests.remove(userId);
    });

    await _saveGuestsToSharedPreferences();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Оборачиваем Scaffold в WillPopScope
      onWillPop: () async {
        // Добавляем onWillPop
        Navigator.of(context)
            .pushReplacementNamed('/menu'); // Переходим на /menu
        return false; // Предотвращаем стандартное поведение "назад"
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFD0E4F7),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFD0E4F7),
          title: SizedBox(
            width: 200,
            height: 60,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              color: const Color(0x993C3C43),
              child: const Padding(
                padding: EdgeInsets.all(0),
                child: Center(
                  child: Text('Список гостей',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: guests.length,
                    itemBuilder: (context, index) {
                      final guestID = guests[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Dismissible(
                          key: Key(guestID),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            _removeGuest(guestID);
                          },
                          child: FutureBuilder<String>(
                            future: _getUserLogin(guestID),
                            builder: (context, snapshot) {
                              String login;
                              String name;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                login = "Загрузка...";
                              } else if (snapshot.hasError) {
                                login = "Ошибка загрузки";
                              } else {
                                login = snapshot.data ?? "Без логина";
                              }
                              return Card(
                                color: const Color(0xA64F81A3),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10),
                                  child: Text(
                                    login,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0x993C3C43),
          onPressed: () {
            // Используем анонимную функцию
            _showAddGuestDialog(context);
          },
          tooltip: 'Добавить гостя',
          child: const Icon(Icons.person_add_alt_outlined, color: Colors.white),
        ),
      ),
    );
  }

  // Диалоговое окно для добавления пользователя по логину
  Future<void> _showAddGuestDialog(BuildContext context) async {
    String login = '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить пользователя по логину'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Введите логин'),
            onChanged: (value) {
              login = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _addGuestByLogin(login);
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}
