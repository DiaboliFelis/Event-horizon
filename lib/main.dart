import 'package:firebase_core/firebase_core.dart';
import 'package:event_horizon/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:event_horizon/presentation/Navigation.dart'; // Импорт вашего класса Navigation
import 'package:flutter_localizations/flutter_localizations.dart'; // Импорт пакета

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Horizon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Pacifico',
      ),
      // Инициализация навигации
      onGenerateRoute: Navigation.generateRoute,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      // Добавьте следующие строки:
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations
            .delegate, // Если используете Cupertino (iOS)
      ],
      supportedLocales: [
        const Locale('ru', 'RU'), // Русский язык
        // Добавьте другие языки, которые вы хотите поддерживать
        // const Locale('en', 'US'), // Английский (США)
      ],
    );
  }
}
