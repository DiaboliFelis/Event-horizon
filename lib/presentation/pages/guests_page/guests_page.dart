//Список гостей
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Убедитесь, что у вас есть иконка

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Метод для показа простого уведомления
Future<void> _sendNotificationToGuest(String fcmToken) async {
  final response = await http.post(
    Uri.parse('hhttp://127.0.0.1:5000/send_notification'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'token': fcmToken}),
  );

  if (response.statusCode == 200) {
    print('Уведомление успешно отправлено');
  } else {
    print('Ошибка при отправке уведомления');
  }
}

Future<void> saveFcmToken(String userId, String fcmToken) async {
  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    'fcmToken': fcmToken,
  }, SetOptions(merge: true));
}

Future<String?> _getFcmTokenForUser(String guestId) async {
//  try {
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('users').doc(guestId).get();

  //   if (doc.exists) {
  //     return doc.data()?['fcmToken'] as String?;
  //   } else {
  //     print("Пользователь с ID $guestId не найден.");
  //     return null;
  //   }
  // } catch (e) {
  //   print("Ошибка при получении FCM токена: $e");
  //   return null;
  // }
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
  bool? _isOrganizer; // Добавляем флаг для хранения статуса организатора

  @override
  void initState() {
    super.initState();
    _loadGuestsFromSharedPreferences();
    _getCurrentUserId();
    _checkOrganizerStatus(); // Добавляем проверку организатора
  }

  Future<void> _checkOrganizerStatus() async {
    try {
      final eventDoc =
          await _firestore.collection('events').doc(widget.documentId).get();

      if (eventDoc.exists) {
        setState(() {
          _isOrganizer = eventDoc['organizerId'] == _auth.currentUser?.uid;
        });
      } else {
        setState(() {
          _isOrganizer = false;
        });
      }
    } catch (e) {
      print('Ошибка при проверке организатора: $e');
      setState(() {
        _isOrganizer = false;
      });
    }
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
        for (String guestId in guests) {
          String? fcmToken = await _getFcmTokenForUser(guestId);
          if (fcmToken != null) {
            await _sendNotificationToGuest(fcmToken);
          } else {
            print("Не удалось получить FCM токен для пользователя $guestId");
          }
        }

        // Добавляем onWillPop
        Navigator.of(context)
            .pushReplacementNamed('/menu'); // Переходим на /menu
        return false; // Предотвращаем стандартное поведение "назад"
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFD0E4F7),
          title: SizedBox(
            child: Text('Список гостей', style: TextStyle(color: Colors.black)),
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
                          direction: _isOrganizer == true
                              ? DismissDirection
                                  .endToStart // Разрешаем свайп только организатору
                              : DismissDirection
                                  .none, // Запрещаем для гостей и пока статус не определен
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
                                color: const Color(0xFFD0E4F7),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 10),
                                    child: Text(
                                      login,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
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
        floatingActionButton:
            _isOrganizer == true // Показываем кнопку только организатору
                ? FloatingActionButton(
//                    backgroundColor: const Color(0x993C3C43),
                    onPressed: () {
                      _showAddGuestDialog(context);
                    },
                    tooltip: 'Добавить гостя',
                    child: const Icon(
                      Icons.person_add_alt_outlined,
                      //color: Colors.white
                    ),
                  )
                : null,
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
