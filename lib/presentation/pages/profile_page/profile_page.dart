import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8ECFF),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsDialog(context);
            },
          ),
        ],
      ),
      body: MyProfile(),
    );
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
                leading: Icon(Icons.edit),
                title: Text("Изменить имя"),
                onTap: () {
                  Navigator.pop(context);
                  _showChangeNameDialog(context);
                },
              ),
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
  void _showChangeNameDialog(BuildContext context) {
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
  }

  // Выбор фото из галереи
  void _pickImageFromGallery(BuildContext context) async {
    /*final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // добавить логику сохранения
    }*/
  }
}

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD8ECFF),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  color: Color(0xFF4F81A3),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/account_icon.png', // Путь для иконки
                    width: 10,
                    height: 10,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              SizedBox(
                width: 300,
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Имя пользователя',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF4F81A3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Увеличенное расстояние между полями
              SizedBox(
                width: 300,
                child: TextField(
                  textAlign: TextAlign.center, // Выравнивание текста по центру
                  decoration: InputDecoration(
                    hintText: 'Логин',
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF4F81A3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
