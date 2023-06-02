import 'package:binary_app/screens/notification/message_by_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:get/get.dart';

import 'screens/course/course_details.dart';
import 'screens/notification/notification_by_id.dart';
import 'screens/notification/notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        const InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
      int id, String title, String body, int seconds) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      const NotificationDetails(
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            sound: const UriAndroidNotificationSound("assets/pop.mp3"),
            icon: '@mipmap/ic_launcher'),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  void initLocalNotifications(
    RemoteMessage message,
  ) async {
    handlleMessage(message);
  }

  void handlleMessage(RemoteMessage message) {
    if (message.data['screen'] == "notf") {
      Get.to(() => NotificationById(id: message.data['id']));
    } else if (message.data['screen'] == "course") {
      Get.to(() => CourseDetails(
            docid: message.data['cour_id'],
          ));
    } else if (message.data['screen'] == "message") {
      Get.to(() => MessageById(
            id: message.data['id'],
          ));
    }
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
