import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/qkrio_timer.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final NotificationService _instance = NotificationService._();

  factory NotificationService() => _instance;

  NotificationService._();

  Future<void> init({
    required Future<void> Function(String?) onSelectNotification,
  }) async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        print('id: $id, title: $title, body: $body, payload: $payload');
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
      macOS: null,
    );

    tz.initializeTimeZones();

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );
  }

  Future<void> scheduleNotificationForTimer(QkrioTimer timer) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'QKRIO_NOTIFICATIONS',
      'QKRIO_NOTIFICATIONS',
      'QKRIO_NOTIFICATIONS',
    );
    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: null,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      timer.hashCode,
      timer.dishName,
      'has just finished cooking',
      tz.TZDateTime.from(timer.started, tz.local).add(timer.duration),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: timer.hashCode.toString(),
    );
  }

  Future<void> cancelNotificationForTimer(QkrioTimer timer) async {
    await _flutterLocalNotificationsPlugin.cancel(timer.hashCode);
  }
}
