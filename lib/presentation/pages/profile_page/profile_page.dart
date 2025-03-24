import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  String _userName = ''; //  Мы больше не используем displayName
  String _userEmail = '';
  String _userImageUrl = '';
  String _userLogin = ''; //  Добавляем переменную для логина

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
        _userImageUrl = user.photoURL ?? '';
      });

      //  Получаем данные пользователя из Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users') // Замени 'users' на имя своей коллекции
              .doc(user.uid)
              .get();

      if (snapshot.exists) {
        setState(() {
          _userLogin = snapshot.data()?['login'] ??
              'Не указано'; //  Получаем логин из Firestore (поле 'login')
          _userName = snapshot.data()?['name'] ??
              'Не указано'; //  Получаем имя пользователя из Firestore (поле 'name')
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8ECFF),
        title: Text('Профиль'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Здесь можно добавить логику для изменения имени или фото
            },
          ),
        ],
      ),
      body: _user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _userImageUrl.isNotEmpty
                        ? NetworkImage(_userImageUrl)
                        : AssetImage('assets/account_icon.png')
                            as ImageProvider,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _userLogin, //  Отображаем логин
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _userEmail,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  // Здесь можно добавить другие данные о пользователе, если они есть
                ],
              ),
            ),
    );
  }
}
