import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_horizon/presentation/pages/registration_page/registration_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:event_horizon/presentation/pages/registration_page/registration_page1.dart';

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
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
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
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Изменить фото"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Выйти из аккаунта"),
                onTap: () {
                  Navigator.pop(context);
                  _logoutUser(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Удалить аккаунт"),
                onTap: () {
                  Navigator.pop(context);
                  _deleteAccount(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Выход из аккаунта
  Future<void> _logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  // Удаление аккаунта
  Future<void> _deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Удаляем данные пользователя из Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        // Удаляем аккаунт
        await user.delete();

        // Переход на страницу регистрации
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось удалить аккаунт: $e')),
      );
    }
  }

// Выбор фото из галереи и загрузка на Firebase Storage
  Future<void> _pickImageFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);

      // Проверка существования файла
      if (await imageFile.exists()) {
        String? userId = FirebaseAuth.instance.currentUser?.uid;

        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Пользователь не найден.')),
          );
          return;
        }

        String fileName = 'profile_image_$userId.jpg';

// Проверка на наличие недопустимых символов
        RegExp regExp = RegExp(r'^[a-zA-Z0-9_\.]+$');
        if (!regExp.hasMatch(fileName)) {
          print("fileName содержит недопустимые символы: $fileName");
        } else {
          print("fileName корректен: $fileName");
        }

        try {
          // Загрузка файла в Firebase Storage
          Reference storageRef =
              FirebaseStorage.instance.ref().child('profile_images/$fileName');
          UploadTask uploadTask = storageRef.putFile(imageFile);
          TaskSnapshot snapshot = await uploadTask;

          if (snapshot.state == TaskState.success) {
            String downloadURL = await snapshot.ref.getDownloadURL();
            print("Изображение успешно загружено: $downloadURL");

            // Обновление photoURL в Firebase Auth
            await FirebaseAuth.instance.currentUser
                ?.updatePhotoURL(downloadURL);

            // Обновление URL в Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({'photoURL': downloadURL});

            // Обновление UI
            if (mounted) {
              setState(() {
                _userImageUrl = downloadURL;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Фото профиля успешно обновлено!')),
              );
            }
          } else {
            print("Ошибка при загрузке изображения: ${snapshot.state}");
          }
        } catch (error) {
          print("Ошибка при загрузке фото: $error");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка при загрузке фото: $error')),
            );
          }
        }
      } else {
        print("Файл не найден");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выбор изображения отменен')),
      );
    }
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
