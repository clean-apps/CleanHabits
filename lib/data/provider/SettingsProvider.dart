import 'dart:convert';

import 'package:CleanHabits/data/WorkManagerService.dart';
import 'package:CleanHabits/domain/TimeArea.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider {
  SharedPreferences prefs;

  String _initDone = 'init-done';
  String _darkMode = 'dark-mode';
  String _firstDayOfWeek = 'first-day-of-week';
  String _briefingMorning = 'briefing-morning';
  String _allowNotifications = 'all-notifications';
  String _weeklyReports = 'weekly-reports';
  String _timeAreas = 'time-areas';

  Future<bool> init() async {
    prefs = await SharedPreferences.getInstance();
    return Future<bool>(() => true);
  }

  Future<bool> loadInitData() async {
    await prefs.setBool(_darkMode, false);
    await prefs.setString(_firstDayOfWeek, 'Mon');
    await prefs.setBool(_allowNotifications, true);
    await prefs.setBool(_briefingMorning, true);
    await prefs.setBool(_weeklyReports, true);

    var _areas = List<TimeArea>();
    _areas.add(TimeArea(
      area: 'Morning',
      startTime: TimeOfDay(hour: 06, minute: 00),
    ));
    _areas.add(TimeArea(
      area: 'Afternoon',
      startTime: TimeOfDay(hour: 12, minute: 00),
    ));
    _areas.add(TimeArea(
      area: 'Evening',
      startTime: TimeOfDay(hour: 18, minute: 00),
    ));
    _areas.add(TimeArea(
      area: 'Night',
      startTime: TimeOfDay(hour: 23, minute: 00),
    ));

    await prefs.setString(_timeAreas, json.encode(_areas));

    var wms = WorkManagerService();
    await wms.activate();

    return prefs.setBool(_initDone, true);
  }

  bool get initDone {
    return prefs.containsKey(_initDone) ? prefs.getBool(_initDone) : false;
  }

  bool get darkMode {
    return prefs.containsKey(_darkMode) ? prefs.getBool(_darkMode) : false;
  }

  set darkMode(bool pMode) {
    prefs.setBool(_darkMode, pMode);
  }

  String get firstDayOfWeek {
    return prefs.getString(_firstDayOfWeek);
  }

  set firstDayOfWeek(String pDay) {
    prefs.setString(_firstDayOfWeek, pDay);
  }

  bool get allowNotifcations {
    return prefs.getBool(_allowNotifications);
  }

  set allowNotifcations(bool pMode) {
    prefs.setBool(_allowNotifications, pMode);
  }

  bool get morningBriefing {
    return prefs.getBool(_briefingMorning);
  }

  set morningBriefing(bool pMode) {
    prefs.setBool(_briefingMorning, pMode);
  }

  bool get weeklyReports {
    return prefs.getBool(_weeklyReports);
  }

  set weeklyReports(bool pMode) {
    prefs.setBool(_weeklyReports, pMode);
  }

  List<TimeArea> get timeArea {
    String spData = prefs.getString(_timeAreas);
    List<dynamic> decData = spData == null ? List() : json.decode(spData);
    var decList = decData.map((mp) => TimeArea.fromJson(mp)).toList();
    return decList;
  }

  set timeArea(List<TimeArea> pValue) {
    prefs.setString(_timeAreas, json.encode(pValue));
  }
}
