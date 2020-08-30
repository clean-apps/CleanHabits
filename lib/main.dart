import 'dart:io';
import 'dart:ui';

import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/data/provider/WidgetDataProvider.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  initializeAndroidWidgets();
  runApp(MyApp());
}

void initializeAndroidWidgets() {
  if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();

    final CallbackHandle callback = PluginUtilities.getCallbackHandle(
      doWidgetUpdate,
    );
    final handle = callback.toRawHandle();

    const channelName = 'com.babanomania.cleanhabits/todayWidget';
    const MethodChannel channel = MethodChannel(channelName);
    channel.invokeMethod('initialize', handle);
  }
}

void doWidgetUpdate() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProviderFactory.initDB();
  await ProviderFactory.settingsProvider.init();

  const channelName = 'com.babanomania.cleanhabits/todayWidget';
  const MethodChannel channel = MethodChannel(channelName);
  channel.setMethodCallHandler(getAppWidgetData);
}

class MyApp extends StatefulWidget {
  final providerFactory = ProviderFactory();
  final sp = ProviderFactory.settingsProvider;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var loading = true;

  @override
  initState() {
    super.initState();

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
    var isDarkMode = widget.sp.darkMode;

    var lightThemeColor = const Color(0xFF056676);
    var darkThemeColor = Colors.red;
    var lightSubtitleColor = Colors.black.withAlpha(130);
    var darkSubtitleColor = Colors.white.withAlpha(180);

    return ThemeData(
      accentColor: isDarkMode ? darkThemeColor : lightThemeColor,
      primaryColor: isDarkMode ? darkThemeColor : lightThemeColor,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,
      textTheme: TextTheme(
          subtitle2: TextStyle(
              color: isDarkMode ? darkSubtitleColor : lightSubtitleColor)),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      cardColor: isDarkMode ? Colors.grey.withOpacity(0.25) : Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
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
              '/settings': (context) => Settings(
                    themeChanged: (val) => setState(() {
                      loading = false;
                    }),
                  ),
              '/settings/time-of-day': (context) => AllTimeOfDay(),
              '/new': (context) => NewHabit(),
              '/edit': (context) => EditHabit(),
              '/welcome': (context) => Welcome(),
            },
          );
  }
}
