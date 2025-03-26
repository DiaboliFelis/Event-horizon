// import 'dart:async';
// import 'package:event_horizon/main.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    // Timer(const Duration(seconds: 5), () {
    // Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyHomePage(title: 'Flutter Demo Home Page'))); //Переход на след ст(вместо MyHomePage)
    // });
    return Scaffold(
      backgroundColor: const Color.fromRGBO(127, 166, 195, 1.0), // Цвет фона
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
        children: [
          Column(
            children: [
              _buildSizedBox(),
              _buildText('Привет!', 30),
              _buildSizedBox(),
              _buildText('Это приложение для создания,', 20),
              _buildText('планирования и управления', 20),
              _buildText('мероприятиями различных форматов:', 20),
              _buildText('от небольших встреч до крупных', 20),
              _buildText('праздников.', 20),
              _buildSizedBox(),
              _buildText('С этим приложением вы можете', 20),
              _buildText('организовывать события, приглашать', 20),
              _buildText('ваших друзей, обмениваться', 20),
              _buildText('информацией и управлять всеми', 20),
              _buildText('аспектами мероприятия в одном', 20),
              _buildText('месте.', 20),
              _buildSizedBox(),
              _buildText('Удачи!', 30),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Кнопка
        backgroundColor: Colors.white, // Цвет кнопки
        onPressed: () {
          Navigator.pushNamed(
              context, '/registration'); // Переход на след страницу по кнопке
        },
        child: const Text('Далее'), // Надпись в кнопке
      ),
    );
  }

  Widget _buildText(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white,
      ),
      textAlign: TextAlign.center, // Выравнивание текста по центру
    );
  }

  Widget _buildSizedBox() {
    return const SizedBox(height: 50); // Отступ
  }
}
