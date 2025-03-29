import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_horizon/presentation/pages/registration_page/registration_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:event_horizon/presentation/pages/registration_page/registration_page1.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  File? _imageFile; // Изменяем тип на File?
  OverlayEntry? _overlayEntry;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadImage();
  }

  Future<void> _loadImage() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("Пользователь не авторизован");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs
        .getString('profile_image_path_$userId'); // Привязка к пользователю

    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Показываем индикатор загрузки
      setState(() {
        _isLoading = true;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final Completer<void> completer = Completer<void>();

      try {
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String filePath = '${appDir.path}/profile_image.jpg';
        final File newImage = File(image.path);
        final File localImage = await newImage.copy(filePath);

        setState(() {
          _imageFile = localImage;
        });
        completer.complete(); // Завершаем Completer, если все прошло успешно
      } catch (e) {
        print("Ошибка при загрузке изображения: $e");
        completer.completeError(e); // Завершаем Completer с ошибкой
      } finally {
        completer.future.then((_) {
          // Выполняем после завершения Completer
          if (mounted) {
            Navigator.of(context).pop();
            setState(() {
              _isLoading = false;
            });
          }
        }).catchError((error) {
          print("Ошибка после Completer: $error");
          if (mounted) {
            Navigator.of(context).pop();
            setState(() {
              _isLoading = false;
            });
          }
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
                  _pickImageFromGallery();
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
  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);
      await _saveImageLocally(imageFile);
    }
  }

  Future<void> _saveImageLocally(File newImage) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _showOverlayMessage('Пользователь не найден.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath =
          '${appDir.path}/profile_image_$userId.jpg'; // Include userId in file name
      final File localImage = await newImage.copy(filePath);

      setState(() {
        _imageFile = localImage;
      });

// Сохраняем путь к изображению в shared_preferences (привязка к пользователю)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path_$userId', localImage.path);

      _showOverlayMessage('Фото профиля успешно обновлено!');
    } catch (e) {
      print("Ошибка сохранения фото локально: $e");
      _showOverlayMessage('Ошибка сохранения фото локально: $e');
    } finally {
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showOverlayMessage(String message) async {
    if (!mounted) {
      print('Widget is no longer mounted, not showing overlay message');
      return;
    }

    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.black54,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    await Future.delayed(const Duration(seconds: 3));

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
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
                        child: _imageFile != null
                            ? Image.file(
                                //Изменяем на Image.file
                                _imageFile!, //Передаем File
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
