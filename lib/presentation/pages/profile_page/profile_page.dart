import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  String _userName = '';
  String _userEmail = '';
  String _userImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Загрузка данных пользователя из Firebase
  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
        _userName = user.displayName ?? 'Не указано';
        _userEmail = user.email ?? 'Не указано';
        _userImageUrl =
            user.photoURL ?? ''; // Если есть фото, то показываем его
      });
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
          ? Center(
              child:
                  CircularProgressIndicator()) // Показываем индикатор загрузки, пока данные не подгрузились
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
                    _userName,
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
