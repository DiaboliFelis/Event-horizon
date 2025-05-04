import 'package:event_horizon/presentation/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:event_horizon/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:event_horizon/presentation/Navigation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Импортируйте firebase_messaging
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission(BuildContext context) async {
  final status = await Permission.notification.status;

  if (status.isDenied) {
    final newStatus = await Permission.notification.request();
    if (newStatus.isGranted) {
      print('Разрешение на уведомления предоставлено');
    } else {
      print('Разрешение на уведомления отклонено');
      // Показываем SnackBar с предложением перейти в настройки
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Для получения уведомлений необходимо предоставить разрешение в настройках приложения.'),
          action: SnackBarAction(
            label: 'Настройки',
            onPressed: () {
              openAppSettings(); // Открываем настройки приложения
            },
          ),
        ),
      );
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Инициализируем FCM после инициализации Firebase
  await AuthService.initializeFCM();
  await NotificationService().init(); // Инициализируйте NotificationService

  runApp(MaterialApp(
    // Оборачиваем MyApp в MaterialApp
    home: Builder(
      builder: (BuildContext context) {
        requestNotificationPermission(context); // Запросите разрешение
        return const MyApp(); // Возвращаем MyApp
      },
    ),
  ));
}

class AuthService {
  static Future<void> initializeFCM() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        print('FCM Token: $token');
        await _saveFCMTokenToServer(token);
      } else {
        print('Failed to get FCM token.');
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        print('Token refreshed: $token');
        _saveFCMTokenToServer(token);
      });
    } catch (e, stackTrace) {
      // Добавляем stackTrace
      print('Error initializing FCM: $e');
      print('StackTrace: $stackTrace'); // Выводим stackTrace
    }
  }

  static Future<void> _saveFCMTokenToServer(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': token,
      }, SetOptions(merge: true));
      print('FCM token saved to Firestore.');
    } catch (e, stackTrace) {
      // Добавляем stackTrace
      print('Error saving FCM token: $e');
      print('StackTrace: $stackTrace'); // Выводим stackTrace
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationService()
        .selectNotificationStream
        .stream
        .listen((String? payload) {
      if (payload != null) {
        // Обработайте нажатие на уведомление
        print('Notification clicked payload: $payload');
        //  Здесь вы можете перейти на другую страницу, отобразить информацию и т.д.
        //  Пример:
        //  Navigator.pushNamed(context, '/event_details', arguments: {'eventId': payload});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Horizon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Pacifico',
      ),
      onGenerateRoute: Navigation.generateRoute,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru', 'RU'),
      ],
    );
  }
}
