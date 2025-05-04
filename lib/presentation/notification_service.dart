import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();

  final BehaviorSubject<String?> selectNotificationStream =
      BehaviorSubject<String?>();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal() {
    init();
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Инициализация таймзон
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // Обработка нажатия на уведомление
        final String? payload = notificationResponse.payload;
        if (kDebugMode) {
          print('Notification selected with payload: $payload');
        }
        selectNotificationStream.add(payload);
      },
    );
  }

  Future<void> showNotification(
      int id, String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Замените на свой channel ID
      'Your Channel Name', // Замените на свой channel name
      channelDescription:
          'Your Channel Description', // Замените на свой channel description
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: payload);
  }

  Future<void> scheduleNotification(int id, String title, String body,
      DateTime scheduledNotificationDateTime, String payload) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      scheduledNotificationDateTime,
      tz.getLocation('Europe/Moscow'),
    );

    if (kDebugMode) {
      print('Scheduling notification for: ${scheduledDate.toString()}');
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',
      channelDescription: 'Your Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      payload: payload,
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle, // обязательный параметр
    );
  }
}
