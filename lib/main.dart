import 'package:CleanHabits/pages/HabitProgress.dart';
import 'package:CleanHabits/pages/NewHabit.dart';
import 'package:CleanHabits/pages/ProgressMain.dart';
import 'package:flutter/material.dart';
import 'package:CleanHabits/pages/TodayView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeColor = const Color(0xFF085da4);
    //var themeColor = Colors.red;

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
