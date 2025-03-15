import 'package:firebase_core/firebase_core.dart';
import 'package:event_horizon/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:event_horizon/presentation/Navigation.dart'; // Импорт вашего класса Navigation

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform, );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Horizon', // Замените на ваше название приложения
      theme: ThemeData(
        primarySwatch: Colors.blue, // Или ваш preferred цвет
        fontFamily: 'Pacifico'
      ),
      // Инициализация навигации
      onGenerateRoute: Navigation.generateRoute,
      initialRoute: '/', // Запуск с SplashScreena
      debugShowCheckedModeBanner: false, // Уберите баннер отладки
    );
  }
}
