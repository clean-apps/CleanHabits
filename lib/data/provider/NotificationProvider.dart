import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider {
  var flutterLocalNotificationsPlugin;
  //
  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  Future<bool> init() async {
    this.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        AndroidInitializationSettings('ic_stat_name'),
        null,
      ),
      onSelectNotification: selectNotification,
    );

    return Future<bool>(() => true);
  }

  showNotificiation({String title, String body, String payload}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'clean-habits-reminders',
      'Reminders',
      'Clean Habits Reminders',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'reminders',
    );
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      null,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
