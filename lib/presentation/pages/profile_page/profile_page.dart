import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8ECFF),
      ),
      body: MyProfile(),
    );
  }
}

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD8ECFF),
      child: Center(
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
    );
  }
}
