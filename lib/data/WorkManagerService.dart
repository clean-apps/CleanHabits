import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/data/provider/NotificationProvider.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/data/provider/WorkmanagerProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkManagerService {
  //
  static var workManagerProvider = WorkManagerProvider();
  static var notificationProvider = NotificationProvider();

  static var hms = HabitMasterService();

  static const _daily_reminder = "daily-reminder";
  static const _habit_reminder = "habit-reminder";
  static const _weekly_briefing = "weekly-briefing";

  static const _daily_reminder_time = TimeOfDay(hour: 09, minute: 00);
  static const _weekly_briefing_time = TimeOfDay(hour: 09, minute: 00);

  var _format = DateFormat("dd-mm-yyyy");

  Future<void> activate() async {
    var now = DateTime.now();
    if (now.hour <= _daily_reminder_time.hour &&
        now.minute <= _daily_reminder_time.minute) {
      //
      workManagerProvider.runPeriodicJob(
        id: "clean-habits-0",
        taskName: _daily_reminder,
        inputData: Map(),
        then: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _daily_reminder_time.hour,
          _daily_reminder_time.minute,
        ),
        frequency: Duration(days: 1),
      );
    } else {
      //
      workManagerProvider.runPeriodicJob(
        id: "clean-habits-0",
        taskName: _daily_reminder,
        inputData: Map(),
        then: DateTime(
          DateTime.now().add(Duration(days: 1)).year,
          DateTime.now().add(Duration(days: 1)).month,
          DateTime.now().add(Duration(days: 1)).day,
          _daily_reminder_time.hour,
          _daily_reminder_time.minute,
        ),
        frequency: Duration(days: 1),
      );
    }

    var weekEnd = DateTime(
      DateTime.now().add(Duration(days: 7 - DateTime.now().weekday)).year,
      DateTime.now().add(Duration(days: 7 - DateTime.now().weekday)).minute,
      DateTime.now().add(Duration(days: 7 - DateTime.now().weekday)).second,
      _weekly_briefing_time.hour,
      _weekly_briefing_time.minute,
    );
    if (weekEnd.isBefore(DateTime.now())) {
      workManagerProvider.runPeriodicJob(
        id: "clean-habits-1",
        taskName: _weekly_briefing,
        inputData: Map(),
        then: weekEnd.add(Duration(days: 1)),
        frequency: Duration(days: 7),
      );
    } else {
      workManagerProvider.runPeriodicJob(
        id: "clean-habits-1",
        taskName: _weekly_briefing,
        inputData: Map(),
        then: weekEnd,
        frequency: Duration(days: 7),
      );
    }
  }

  Future<void> deactivate() async {
    return await workManagerProvider.cancelAllJobs();
  }

  callback(String taskName, Map<String, dynamic> inputData) async {
    switch (taskName) {
      case _daily_reminder:
        await callbackDailyScheduler(inputData);
        break;

      case _habit_reminder:
        await callbackDailyScheduler(inputData);
        break;

      case _weekly_briefing:
        await callbackWeeklyBriefing(inputData);
        break;

      default:
    }
  }

  callbackDailyScheduler(Map<String, dynamic> inputData) async {
    hms.schedule();
  }

  addHabitReminder(int habitId, DateTime then) {
    var thenString = _format.format(then);
    workManagerProvider.runSingleJobAt(
      id: "clean-habits-$habitId-$thenString",
      taskName: _habit_reminder,
      inputData: {
        "habit-id": habitId,
      },
      then: then,
    );
  }

  callbackHabitReminder(Map<String, dynamic> inputData) async {
    var habitId = inputData["habit-id"];
    var forDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    var habitMaster =
        await ProviderFactory.habitMasterProvider.getData(habitId);
    var habitRunData = await ProviderFactory.habitRunDataProvider.getData(
      forDate,
      habitId,
    );
    var target = habitMaster.isYNType ? 1 : habitMaster.timesTarget;
    if (habitRunData.progress < target) {
      var lastRunData = habitRunData.prevRunDate == null
          ? null
          : await ProviderFactory.habitRunDataProvider.getData(
              habitRunData.prevRunDate,
              habitId,
            );
      var lastCompleted =
          lastRunData == null ? false : lastRunData.progress < target;

      ProviderFactory.notificationProvider.showNotificiation(
        title: habitMaster.title,
        body: lastRunData == null
            ? "Reminder to complete this now"
            : lastCompleted
                ? "Time to complete it again"
                : "Last time you didn't complete this, time to get it done now ",
      );
    }
  }

  callbackWeeklyBriefing(Map<String, dynamic> inputData) {
    ProviderFactory.notificationProvider.showNotificiation(
      title: "Weekly progress report",
      body: "Your weekly habit progress is now ready",
    );
  }
}
