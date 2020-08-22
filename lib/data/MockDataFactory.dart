import 'dart:math';

import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/data/HabitStatsService.dart';
import 'package:CleanHabits/data/ProgressStatsService.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/new/SelectChecklistType.dart';
import 'package:CleanHabits/widgets/new/SelectRepeat.dart';
import 'package:flutter/material.dart';

class MockDataFactory {
  static var providerFactory = ProviderFactory();

  static var habitMasterService = HabitMasterService();
  static var habitStatsService = HabitStatsService();
  static var progressStatsService = ProgressStatsService();

  static create({int daysToMock, double motivation}) async {
    var rng = Random();

    await _removeStaleData();

    var startDate = DateTime.now().subtract(Duration(days: daysToMock));
    var endDates = DateTime.now();
    var allDates = _calculateDaysInterval(startDate, endDates);

    await _createHabits(startDate);
    debugPrint('-creation done-');

    // scheduling
    for (var eachDate in allDates)
      await habitMasterService.schedule(forDate: eachDate);
    debugPrint('-scheduling done-');

    // complete habits
    for (var eachDate in allDates) {
      var habits = await habitMasterService.list(eachDate);
      for (var hbt in habits) {
        if (hbt.isYNType) {
          hbt.ynCompleted = rng.nextInt(10) <= (motivation * 10) ? true : false;
        } else {
          hbt.timesProgress = rng.nextInt(10) >= ((1 - motivation) * 10)
              ? hbt.timesTarget
              : rng.nextInt(10) / 10 * hbt.timesTarget;
        }

        await habitMasterService.updateStatus(
          habit: hbt,
          dateTime: eachDate,
        );
      }
    }
    debugPrint('-status update done-');

    var habitsList = await ProviderFactory.habitMasterProvider.list();
    debugPrint(habitsList.length == 0 ? 'No Mock Data' : 'Mock Data Present');
  }

  static _removeStaleData() async {
    //:~ remove stale data starts
    var habitsList = await ProviderFactory.habitMasterProvider.list();
    habitsList.forEach(
      (hb) async => await ProviderFactory.habitMasterProvider.delete(hb.id),
    );

    var runDataList = await ProviderFactory.habitRunDataProvider.list();
    runDataList.forEach(
      (rd) async => await ProviderFactory.habitRunDataProvider.delete(rd.id),
    );

    var habitsLastRuns = await ProviderFactory.habitLastRunDataProvider.list();
    habitsLastRuns.forEach(
      (lr) async =>
          await ProviderFactory.habitLastRunDataProvider.delete(lr.id),
    );

    var srvLastRuns = await ProviderFactory.serviceLastRunProvider.list();
    srvLastRuns.forEach(
      (lr) async => await ProviderFactory.serviceLastRunProvider.delete(lr.id),
    );
    //:~ remove stale data ends
  }

  static Future<List<Habit>> _createHabits(startDate) async {
    var rng = Random();
    var mockTitles = ['Morning Jog']; //, 'Eat Healthy', 'Get Up Early'];
    var itrRepeats = [
      Repeats(none: true),
      Repeats(
        none: false,
        isWeekly: true,
        hasMon: true,
        hasWed: true,
        hasFri: true,
      ),
      Repeats(
        none: false,
        interval: 2,
      ),
    ].iterator;

    return await Future.wait(
      mockTitles.map((title) async {
        itrRepeats.moveNext();
        var habit = await habitMasterService.create(
          title: title,
          fromDate: startDate,
          type: ChecklistType(
            isSimple: true,
            times: 1,
            timesType: null,
          ),
          reminder: TimeOfDay(
            hour: rng.nextInt(24) - 1,
            minute: rng.nextInt(60) - 1,
          ),
          repeat: itrRepeats.current,
          timeOfDay: "All Day",
        );

        return habit;
      }),
    );
  }

  static List<DateTime> _calculateDaysInterval(
    DateTime startDate,
    DateTime endDate,
  ) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }
}
