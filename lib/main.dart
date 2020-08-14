import 'package:CleanHabits/pages/HabitProgress.dart';
import 'package:CleanHabits/pages/NewHabit.dart';
import 'package:CleanHabits/pages/ProgressMain.dart';
import 'package:flutter/material.dart';
import 'package:CleanHabits/pages/TodayView.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //
  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  showNotificiation() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_name');
    var initializationSettings =
        InitializationSettings(initializationSettingsAndroid, null);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',
    );
    var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics,
      null,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'sample title',
      'sample body',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeColor = const Color(0xFF085da4);
    //var themeColor = Colors.red;

    // Notifications
    showNotificiation();
    //

    return MaterialApp(
      theme: ThemeData(
        accentColor: themeColor,
        primaryColor: themeColor,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          subtitle2: TextStyle(
            color: Colors.black.withAlpha(130),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TodayView(),
        '/habit/progress': (context) => HabitProgress(),
        '/progress': (context) => ProgressMain(),
        '/new': (context) => NewHabit(),
      },
    );
  }
}
