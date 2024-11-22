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
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Pacifico'),                        // Шрифт текста во всем окне
        home: Scaffold(
        backgroundColor: const Color.fromRGBO(127, 166, 195, 1.0),  // Цвет фона
        body: const Row(
          // color: const Color.fromRGBO(127, 166, 195, 1.0),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: 150,),  // Отступ от верхней части экрана
                Text('Привет!', style: TextStyle(fontSize: 30, color: Colors.white,),),
                
                SizedBox(height: 50,),
                Text('Это приложение для создания,', style: TextStyle(fontSize: 20, color: Colors.white,),),
                Text('планирования и управления', style: TextStyle(fontSize: 20, color: Colors.white,),),
                Text('мероприятиями различных форматов:', style: TextStyle(fontSize: 20, color: Colors.white,),),
                Text('от небольших встреч до крупных', style: TextStyle(fontSize: 20, color: Colors.white,),),
                Text('праздников.', style: TextStyle(fontSize: 20, color: Colors.white,),),

                SizedBox(height: 50,),
                Text('С этим приложением вы можете', style: TextStyle(fontSize: 20, color: Colors.white,),),
                Text('организовывать события, приглашать', style: TextStyle(fontSize: 20, color: Colors.white,),),
                Text('ваших друзей, обмениваться', style: TextStyle(fontSize: 20, color: Colors.white,),),
                Text('информацией и управлять всеми', style: TextStyle(fontSize: 20, color: Colors.white,),),
                Text('аспектами мероприятия в одном', style: TextStyle(fontSize: 20, color: Colors.white,),),
                Text('месте.', style: TextStyle(fontSize: 20, color: Colors.white,),),

                SizedBox(height: 50,),
                Text('Удачи!', style: TextStyle(fontSize: 30, color: Colors.white,),),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(  // Кнопка
          backgroundColor: Colors.white,          // Цвет кнопки
          onPressed: () {
            Navigator.pushNamed(context,'/2');      // Переход на след страницу по кнопке
          },
          child: const Text('Далее'),              // Надпись в кнопке
        ),
      ),
    );
  }
}