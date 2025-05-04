import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal() {
    init();
  }

  // Subject для обработки выбора уведомлений
  final BehaviorSubject<String?> selectNotificationStream =
      BehaviorSubject<String?>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Инициализация таймзон
    tz.initializeTimeZones();

    // Настройки для Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            '@drawable/launch_background'); // Замените 'app_icon' на имя вашей иконки

    /*// Настройки для iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );*/

    // Общие настройки для обеих платформ
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      //iOS: initializationSettingsIOS,
    );

    // Инициализация плагина
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        // Обработка выбора уведомления
        selectNotificationStream.add(notificationResponse.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  // Обработка выбора уведомления в фоне (только для Android)
  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    // Обработка нажатия на уведомление в фоне
    if (notificationResponse.payload != null) {
      print(
          'Notification clicked in background with payload: ${notificationResponse.payload}');
      // Здесь можно выполнить необходимые действия, например, сохранить payload в глобальной переменной
      // и обработать его позже при запуске приложения
    }
  }

  // Метод для показа простого уведомления
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'main_channel', // Идентификатор канала (важен для Android)
      'Main Channel', // Название канала
      channelDescription: 'Main notification channel', // Описание канала
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Метод для планирования уведомления на определенное время
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel', // Идентификатор канала для запланированных уведомлений
          'Scheduled Channel', // Название канала
          channelDescription:
              'Scheduled notification channel', // Описание канала
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Метод для отмены уведомления по ID
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // Метод для отмены всех уведомлений
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
