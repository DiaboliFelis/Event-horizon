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

  // Отображение диалогового окна
  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Выберите действие"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*ListTile(
                leading: Icon(Icons.edit),
                title: Text("Изменить имя"),
                onTap: () {
                  Navigator.pop(context);
                  _showChangeNameDialog(context);
                },
              ),*/
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Изменить фото"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Отображение диалога изменения имени
  /*void _showChangeNameDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Изменить имя"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Введите новое имя"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                String newName = nameController.text;
                if (newName.isNotEmpty) {
                  // добавить логику сохранения
                }
                Navigator.pop(context);
              },
              child: Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }*/

  // Выбор фото из галереи
  void _pickImageFromGallery(BuildContext context) async {
    /*final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // добавить логику сохранения
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8ECFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8ECFF),
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showOptionsDialog(context);
            },
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      margin: const EdgeInsets.only(top: 50),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4F81A3),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: _userImageUrl.isNotEmpty
                            ? Image.network(
                                _userImageUrl,
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/account_icon.png',
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/account_icon.png', // Путь для иконки
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        textAlign: TextAlign.center,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: _userLogin, //  Имя пользователя
                          hintStyle: TextStyle(
                            color: Color.fromARGB(179, 15, 14, 14),
                            fontSize: 25,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF4F81A3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
