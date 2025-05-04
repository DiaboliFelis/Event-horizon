import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_horizon/presentation/pages/registration_page/registration_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  String _userName = '';
  String _userEmail = '';
  String _userImageUrl = '';
  String _userLogin = '';
  File? _imageFile;
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
    if (userId == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image_path_$userId');

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

      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _userLogin = snapshot.data()?['login'] ?? 'Не указано';
          _userName = snapshot.data()?['name'] ?? 'Не указано';
        });
      }
    }
  }

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
                leading: Icon(Icons.edit),
                title: Text("Изменить имя"),
                onTap: () {
                  Navigator.pop(context);
                  _editName();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Изменить фото"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_forever),
                title: Text("Удалить фото"),
                onTap: () {
                  Navigator.pop(context);
                  _deleteProfileImage();
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
                  _confirmDeleteAccount(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editName() async {
    final TextEditingController nameController =
        TextEditingController(text: _userName);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Изменить имя"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Введите новое имя",
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Отмена"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Сохранить"),
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  Navigator.of(context).pop();
                  await _updateUserName(nameController.text.trim());
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserName(String newName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'name': newName});

      setState(() {
        _userName = newName;
      });

      _showOverlayMessage('Имя успешно изменено!');
    } catch (e) {
      _showOverlayMessage('Ошибка при изменении имени: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      final String filePath = '${appDir.path}/profile_image_$userId.jpg';
      final File localImage = await newImage.copy(filePath);

      setState(() {
        _imageFile = localImage;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path_$userId', localImage.path);

      _showOverlayMessage('Фото профиля успешно обновлено!');
    } catch (e) {
      _showOverlayMessage('Ошибка сохранения фото: $e');
    } finally {
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProfileImage() async {
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? imagePath = prefs.getString('profile_image_path_$userId');

      if (imagePath != null) {
        File file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
        await prefs.remove('profile_image_path_$userId');
      }

      setState(() {
        _imageFile = null;
      });

      _showOverlayMessage('Фото профиля удалено.');
    } catch (e) {
      _showOverlayMessage('Ошибка удаления фото: $e');
    } finally {
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Подтверждение удаления"),
          content: Text(
              "Вы уверены, что хотите удалить аккаунт? Это действие нельзя отменить."),
          actions: [
            TextButton(
              child: Text("Отмена"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Удалить"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final scaffold = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await user.delete();
      await SharedPreferences.getInstance().then((prefs) => prefs.clear());

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => RegistrationPage()),
        (route) => false,
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(content: Text("Ошибка: ${e.toString()}")),
      );
    }
  }

  void _showOverlayMessage(String message) async {
    if (!mounted) return;

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
                                _imageFile!,
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/cat_zont.png',
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/cat_zont.png',
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Логин',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            textAlign: TextAlign.center,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: _userLogin,
                              hintStyle: const TextStyle(
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Имя пользователя',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            textAlign: TextAlign.center,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: _userName,
                              hintStyle: const TextStyle(
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
                        ],
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
