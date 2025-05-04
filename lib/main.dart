import 'package:firebase_core/firebase_core.dart';
import 'package:event_horizon/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:event_horizon/presentation/Navigation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:event_horizon/notification_service.dart'; // Импортируйте NotificationService
import 'package:rxdart/rxdart.dart'; // Import RxDart
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");
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
