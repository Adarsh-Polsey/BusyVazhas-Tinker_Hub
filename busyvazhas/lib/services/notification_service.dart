import 'dart:developer';

import 'package:busyvazhas/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isSilentMode = false;

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(initializationSettings);
  }

  void setSilentMode(bool value) {
    _isSilentMode = value;
  }

  Future<void> showNotification({
   required NotificationItem notification,required Icon icon
  }) async {
    if (_isSilentMode) return;

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'busy_vazhas_channel',
      'BusyVazhas Notifications',icon:icon ,
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
    );

    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notifications.show(
      0,notification.platform,
      "${notification.sender} + ${notification.message}",
      platformChannelSpecifics,
      payload: "",
    );
  }

  Future<void> clearNotifications() async {
    await _notifications.cancelAll();
  }
}
