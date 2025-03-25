//Список гостей

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return guestListScreen();
  }
}

class guestListScreen extends StatefulWidget {
  @override
  guestListScreenState createState() => guestListScreenState();
}

class guestListScreenState extends State<guestListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<String> guests = [];
  String currentUserId = '';

  void _loadGuests() async {
    final doc = await _firestore.collection('user_guests').doc(currentUserId).get();
    if (doc.exists) {
      setState(() {
        guests.clear();
        guests.addAll(List<String>.from(doc.data()?['guests'] ?? []));
      });
    }
  }

  void _getCurrentUserId() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
      _loadGuests();
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _addGuestByLogin(String login) async {
    if (login.isEmpty) return;

    try {
      // Ищем пользователя по логину (email)
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

      // Добавляем в список гостей
      setState(() {
        guests.add(guestUserId);
      });

      // Обновляем данные в Firestore
      await _firestore.collection('user_guests').doc(currentUserId).set({
        'guests': FieldValue.arrayUnion([guestUserId]),
      }, SetOptions(merge: true));

    } catch (e) {
      _showErrorDialog('Ошибка при добавлении гостя: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddGuestDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFD0E4F7),
          title: SizedBox(
            width: 300,
            height: 100,
            child: Center(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                color: const Color(0x993C3C43),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                  child: Text(
                    'Добавить гостя',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          content: Card(
            color: const Color(0xA64F81A3),
            child: TextField(
              controller: controller,
              decoration:
                  const InputDecoration(labelText: 'Введите логин гостя'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String login = controller.text.trim();
                _addGuestByLogin(login);
                Navigator.of(context).pop();
              },
              child: const Text('Добавить'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0E4F7),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFD0E4F7),
        title: SizedBox
        ( 
          width: 200,
          height: 60,
        child: Card
          (
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          color: const Color(0x993C3C43),
          child: const Padding
            (
            padding: EdgeInsets.all(0) ,
            child: Center
            (
            child: Text('Список гостей', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Card(
                            color: const Color(0xA64F81A3),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                              child:
                                Text(guests[index], style: const TextStyle(color: Colors.white),
                              ),
                          ),
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
        onPressed: _showAddGuestDialog,
        tooltip: 'Добавить гостя',
        child: const Icon(Icons.person_add_alt_outlined, color: Colors.white,),
      ),
    );
  }
}
