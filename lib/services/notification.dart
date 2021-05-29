import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/qkrio_scheduled_timer.dart';
import '../models/qkrio_timer.dart';

class NotificationService {
  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'QKRIO_NOTIFICATIONS',
    'QKRIO_NOTIFICATIONS',
    'QKRIO_NOTIFICATIONS',
  );
  static const IOSNotificationDetails _iosNotificationDetails =
      IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iosNotificationDetails,
    macOS: null,
  );

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final NotificationService _instance = NotificationService._();

  factory NotificationService() => _instance;

  NotificationService._();

  Future<void> init({
    required Future<void> Function(String?) onSelectNotification,
  }) async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('ic_stat_name');

    const IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const InitializationSettings initializationSettings =
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

  Future<void> showNotificationForTimer(QkrioTimer timer) async {
    await _flutterLocalNotificationsPlugin.show(
      timer.hashCode,
      timer.dish.dishName,
      'will cook for ${timer.dish.presentableDuration()}',
      _notificationDetails,
      // sending timer.hashCode as payload would cancel timer if user clicks on notification
      payload: null,
    );
  }

  Future<void> scheduleNotificationForTimer(QkrioTimer timer) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      timer.hashCode,
      timer.dish.dishName,
      'has just finished cooking',
      tz.TZDateTime.from(timer.started, tz.local).add(timer.dish.duration),
      _notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: notificationPayloadForTimer(timer),
    );
  }

  Future<void> cancelNotificationForTimer(QkrioTimer timer) async {
    await _flutterLocalNotificationsPlugin.cancel(timer.hashCode);
  }

  Future<void> scheduleNotificationForScheduledTimer(
      QkrioScheduledTimer scheduledTimer) async {
    if (scheduledTimer.notifyBefore != null) {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        scheduledTimer.hashCode,
        'Reminder: ${scheduledTimer.dish.dishName}',
        'Start cooking in ${scheduledTimer.notifyBefore!.presentable()}',
        tz.TZDateTime.from(
          scheduledTimer.start
              .subtract(scheduledTimer.notifyBefore!.toDuration()),
          tz.local,
        ),
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: notificationPayloadForScheduled(scheduledTimer),
      );
    }
  }

  Future<void> cancelNotificationForScheduledTimer(
      QkrioScheduledTimer scheduledTimer) async {
    await _flutterLocalNotificationsPlugin.cancel(scheduledTimer.hashCode);
  }

  static String notificationPayloadForTimer(QkrioTimer timer) {
    return 'T${timer.hashCode}';
  }

  static String notificationPayloadForScheduled(QkrioScheduledTimer timer) {
    return 'S${timer.hashCode}';
  }
}
