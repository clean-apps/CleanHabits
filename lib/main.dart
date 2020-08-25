import 'package:CleanHabits/data/provider/NotificationProvider.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/pages/AllHabits.dart';
import 'package:CleanHabits/pages/AllTimeOfDay.dart';
import 'package:CleanHabits/pages/EditHabit.dart';
import 'package:CleanHabits/pages/HabitProgress.dart';
import 'package:CleanHabits/pages/LoadingScreen.dart';
import 'package:CleanHabits/pages/ProgressMain.dart';
import 'package:CleanHabits/pages/Settings.dart';
import 'package:CleanHabits/pages/TodayView.dart';
import 'package:CleanHabits/pages/NewHabit.dart';
import 'package:CleanHabits/pages/Welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final providerFactory = ProviderFactory();
  final notificationProvider = NotificationProvider();
  final sp = ProviderFactory.settingsProvider;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var loading = true;

  var notificationInit = false;
  var notificationTest = false;

  @override
  initState() {
    super.initState();

    widget.notificationProvider.init().then(
          (sts) => setState(() {
            notificationInit = true;
          }),
        );

    ProviderFactory.init().then(
      (sts) => setState(() {
        loading = false;
      }),
    );
  }

  @override
  void dispose() async {
    await ProviderFactory.close();
    super.dispose();
  }

  ThemeData _theme(BuildContext context) {
    var themeColor = const Color(0xFF056676);
    //var themeColor = const Color(0xFF085da4);
    //var themeColor = Colors.red;

    return ThemeData(
      accentColor: themeColor,
      primaryColor: themeColor,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        subtitle2: TextStyle(
          color: Colors.black.withAlpha(130),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Demo Notifications
    if (notificationInit && !notificationTest)
      widget.notificationProvider
          .showNotificiation(
            title: 'Habit Reminder',
            body: 'Read 20 Pages',
            payload: 'habit-id-1',
          )
          .then(
            (sts) => setState(() {
              notificationTest = true;
            }),
          );
    //

    return loading
        ? Loading()
        : MaterialApp(
            theme: _theme(context),
            initialRoute: widget.sp.initDone ? '/' : '/welcome',
            routes: {
              '/': (context) => TodayView(),
              '/habit/progress': (context) => HabitProgress(),
              '/habit/all': (context) => AllHabits(),
              '/progress': (context) => ProgressMain(),
              '/settings': (context) => Settings(),
              '/settings/time-of-day': (context) => AllTimeOfDay(),
              '/new': (context) => NewHabit(),
              '/edit': (context) => EditHabit(),
              '/welcome': (context) => Welcome(),
            },
          );
  }
}
