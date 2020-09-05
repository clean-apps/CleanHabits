import 'package:CleanHabits/data/WorkManagerService.dart';
import 'package:CleanHabits/data/domain/HabitLastRunData.dart';
import 'package:CleanHabits/data/domain/HabitMaster.dart';
import 'package:CleanHabits/data/domain/HabitRunData.dart';
import 'package:CleanHabits/data/domain/ServiceLastRun.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/widgets/new/SelectChecklistType.dart';
import 'package:CleanHabits/widgets/new/SelectRepeat.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HabitMasterService {
  //
  var hmp = ProviderFactory.habitMasterProvider;
  var lrdp = ProviderFactory.habitLastRunDataProvider;
  var rdp = ProviderFactory.habitRunDataProvider;
  var slrp = ProviderFactory.serviceLastRunProvider;
  var wms = WorkManagerService();
  //
  Future<List<Habit>> list(DateTime target) async {
    var habitRunDatas = await this.rdp.listForDate(DateTime(
          target.year,
          target.month,
          target.day,
        ));

    var habitsList = List<Habit>();
    for (var rd in habitRunDatas) {
      var lkpHabit = await _getHabitData(rd);
      habitsList.add(lkpHabit);
    }

    return habitsList;
  }

  Future<Habit> _getHabitData(HabitRunData pRunData) async {
    var habitMaster = await hmp.getData(pRunData.habitId);
    return pRunData.toDomain(habitMaster.toDomain());
  }

  Future<Habit> create({
    String title,
    Repeats repeat,
    DateTime fromDate,
    ChecklistType type,
    TimeOfDay reminder,
    String timeOfDay,
  }) async {
    //
    var data = HabitMaster.fromDomain(
      title,
      repeat,
      DateTime(fromDate.year, fromDate.month, fromDate.day),
      type,
      reminder,
      timeOfDay,
    );
    var habitMaster = await this.hmp.insert(data);
    var habit = habitMaster.toDomain();

    if (fromDate.isBefore(DateTime.now())) {
      var checkDate = DateTime.fromMillisecondsSinceEpoch(
        fromDate.millisecondsSinceEpoch,
        isUtc: false,
      );
      while (checkDate.isBefore(DateTime.now().add(Duration(days: 1)))) {
        await scheduleHabit(
          habit: habitMaster,
          forDate: DateTime(checkDate.year, checkDate.month, checkDate.day),
        );

        checkDate = checkDate.add(Duration(days: 1));
      }
    }

    return habit;
  }

  Future<Habit> update({
    int id,
    String title,
    Repeats repeat,
    DateTime fromDate,
    ChecklistType type,
    TimeOfDay reminder,
    String timeOfDay,
  }) async {
    //
    var habitMaster = HabitMaster.fromDomain(
      title,
      repeat,
      DateTime(fromDate.year, fromDate.month, fromDate.day),
      type,
      reminder,
      timeOfDay,
    );
    habitMaster.id = id;
    await this.hmp.update(habitMaster);
    var habit = habitMaster.toDomain();

    var nowDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    var tomDate = DateTime(
      DateTime.now().add(Duration(days: 1)).year,
      DateTime.now().add(Duration(days: 1)).month,
      DateTime.now().add(Duration(days: 1)).day,
    );

    var lastRun = await this.lrdp.getHabitData(habitMaster.id);

    if (lastRun.lastUpdated.isAtSameMomentAs(nowDate)) {
      //today
      await this.rdp.deleteDataFor(habitMaster.id, nowDate);
      await this.lrdp.deleteData(habitMaster.id);
      await scheduleHabit(
        habit: habitMaster,
        forDate: nowDate,
      );
    }

    if (lastRun.lastUpdated.isAtSameMomentAs(tomDate)) {
      //today
      await this.rdp.deleteDataFor(habitMaster.id, nowDate);
      await this.lrdp.deleteData(habitMaster.id);
      await scheduleHabit(
        habit: habitMaster,
        forDate: nowDate,
      );

      //tomorrow
      await this.rdp.deleteDataFor(habitMaster.id, tomDate);
      await scheduleHabit(
        habit: habitMaster,
        forDate: tomDate,
      );
    }

    return habit;
  }

  Future<int> countTodaysHabits() async {
    var forDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    var habitList = await this.rdp.listForDate(forDate);
    return habitList == null ? 0 : habitList.length;
  }

  Future<ServiceLastRun> schedule({DateTime forDate}) async {
    if (forDate == null) {
      forDate = DateTime.now().add(
        Duration(days: 1),
      );
    }

    // remove hour minutes
    var runForDate = DateTime(forDate.year, forDate.month, forDate.day);

    // run schedule for each habits
    var habits = await this.hmp.list();
    if (habits != null) {
      await Future.wait(
        habits.map((hbt) async {
          return await scheduleHabit(habit: hbt, forDate: runForDate);
        }),
      );
    }

    // update service last run
    var lastRun = await this.slrp.list();
    if (lastRun == null || lastRun.length == 0) {
      var lastRunDataMap = {
        'last_updated': DateTime(
          runForDate.year,
          runForDate.month,
          runForDate.day,
        ).millisecondsSinceEpoch,
      };
      var sLastRunData = ServiceLastRun.fromMap(lastRunDataMap);
      return this.slrp.insert(sLastRunData);
      //
    } else {
      lastRun[0].lastUpdated = DateTime(
        runForDate.year,
        runForDate.month,
        runForDate.day,
      );
      await this.slrp.update(lastRun[0]);
      return lastRun[0];
    }
  }

  Future<HabitMaster> scheduleHabit({
    HabitMaster habit,
    DateTime forDate,
  }) async {
    var applicable = await isApplicable(
      habit,
      DateTime(forDate.year, forDate.month, forDate.day),
    );

    var lastRunData = await this.lrdp.getHabitData(habit.id);
    var lastRunDate = lastRunData == null ? null : lastRunData.lastUpdated;
    var alreadyPresent = lastRunData != null &&
        (lastRunData.lastUpdated.isAtSameMomentAs(
                DateTime(forDate.year, forDate.month, forDate.day)) ||
            lastRunData.lastUpdated
                .isAfter(DateTime(forDate.year, forDate.month, forDate.day)));

    if (applicable && !alreadyPresent) {
      // insert run data
      var runDataMap = {
        '_habit_id': habit.id,
        columnTargetDate: DateTime(forDate.year, forDate.month, forDate.day)
            .millisecondsSinceEpoch,
        columnTarget: habit.isYNType ? 1 : habit.timesTarget,
        columnProgress: 0,
        columnCurrentStreak: 0,
        columnPrevRunDate: lastRunDate == null
            ? null
            : DateTime(lastRunDate.year, lastRunDate.month, lastRunDate.day)
                .millisecondsSinceEpoch,
      };
      var runData = HabitRunData.fromMap(runDataMap);
      this.rdp.insert(runData);

      //add reminder
      var notifStarts = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        habit.reminder == null ? 0 : habit.reminder.hour,
        habit.reminder == null ? 0 : habit.reminder.minute,
      );
      if (habit.reminder != null && notifStarts.isAfter(forDate)) {
        this.wms.addHabitReminder(
              habit.id,
              DateTime(
                forDate.year,
                forDate.month,
                forDate.day,
                habit.reminder.hour,
                habit.reminder.minute,
              ),
            );
      }

      // update last run data
      var lastRunData = await this.lrdp.getHabitData(habit.id);
      if (lastRunData == null) {
        var lrData = {
          '_habit_id': habit.id,
          'last_updated': DateTime(forDate.year, forDate.month, forDate.day)
              .millisecondsSinceEpoch,
        };
        lastRunData = HabitLastRunData.fromMap(lrData);
        await this.lrdp.insert(lastRunData);
      } else {
        lastRunData.lastUpdated = DateTime(
          forDate.year,
          forDate.month,
          forDate.day,
        );
        await this.lrdp.update(lastRunData);
      }
    }

    return habit;
  }

  Future<bool> updateStatus({Habit habit, DateTime dateTime}) async {
    //
    var forDate = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    var runData = await this.rdp.getData(forDate, habit.id);

    if (runData != null) {
      //set skipped
      runData.hasSkipped = habit.isSkipped;

      // prev day run data
      var prevDate = runData == null ? null : runData.prevRunDate;
      var prevRunData =
          prevDate == null ? null : await this.rdp.getData(prevDate, habit.id);

      if (habit.isYNType) {
        if (habit.ynCompleted) {
          runData.progress = 1;
          if (prevRunData != null && prevRunData.progress == 1) {
            runData.currentStreak = prevRunData.currentStreak + 1;
            runData.streakStartDate = prevRunData.streakStartDate;
            runData.hasStreakEnded = true;

            prevRunData.hasStreakEnded = false;

            await this.rdp.update(runData);
            await this.rdp.update(prevRunData);
            //
          } else if (prevRunData != null) {
            runData.currentStreak = 1;
            runData.streakStartDate = forDate;
            runData.hasStreakEnded = false;

            prevRunData.currentStreak = 0;
            prevRunData.hasStreakEnded = true;

            await this.rdp.update(runData);
            await this.rdp.update(prevRunData);
          } else {
            runData.currentStreak = 1;
            runData.streakStartDate = forDate;
            runData.hasStreakEnded = false;

            await this.rdp.update(runData);
          }
        } else {
          runData.progress = 0;
          runData.currentStreak = 0;
          runData.streakStartDate = null;
          runData.hasStreakEnded = false;

          await this.rdp.update(runData);
          //
        }
      } else {
        if (habit.timesProgress == habit.timesTarget) {
          runData.progress = habit.timesProgress;
          if (prevRunData != null &&
              prevRunData.progress == habit.timesTarget) {
            runData.currentStreak = prevRunData.currentStreak + 1;
            runData.streakStartDate = prevRunData.streakStartDate;
            runData.hasStreakEnded = true;

            prevRunData.hasStreakEnded = false;

            await this.rdp.update(runData);
            await this.rdp.update(prevRunData);
            //
          } else if (prevRunData != null) {
            runData.currentStreak = 1;
            runData.streakStartDate = forDate;
            runData.hasStreakEnded = false;

            prevRunData.currentStreak = 0;
            prevRunData.hasStreakEnded = true;

            await this.rdp.update(runData);
            await this.rdp.update(prevRunData);
          } else {
            runData.currentStreak = 1;
            runData.streakStartDate = forDate;
            runData.hasStreakEnded = false;

            await this.rdp.update(runData);
          }
        } else {
          runData.progress = habit.timesProgress;
          runData.currentStreak = 0;
          runData.streakStartDate = null;
          runData.hasStreakEnded = true;

          await this.rdp.update(runData);
          //
        }
      }

      return Future(() => true);
    } else {
      return Future(() => false);
    }
  }

  Future<bool> isApplicable(HabitMaster habit, DateTime forDate) async {
    var today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    var checkFor = DateTime(
      forDate.year,
      forDate.month,
      forDate.day,
    );

    if (habit.isNone) {
      // no repetations present, repeat everyday
      return true;
      //
    } else if (habit.isWeekly) {
      // check for day of week
      var checkDay = DateFormat("E").format(checkFor);
      if (checkDay == "Sun" && habit.hasSun) {
        return true;
      } else if (checkDay == "Mon" && habit.hasMon) {
        return true;
      } else if (checkDay == "Tue" && habit.hasTue) {
        return true;
      } else if (checkDay == "Wed" && habit.hasWed) {
        return true;
      } else if (checkDay == "Thu" && habit.hasThu) {
        return true;
      } else if (checkDay == "Fri" && habit.hasFri) {
        return true;
      } else if (checkDay == "Sat" && habit.hasSat) {
        return true;
      } else {
        return false;
      }
      //
    } else {
      //interval repeats
      var lastRunData = await this.lrdp.getHabitData(habit.id);
      if (lastRunData != null) {
        //last run data is present, use that
        var days = checkFor.difference(lastRunData.lastUpdated);
        return (days.inDays >= habit.repDuation);
        //
      } else {
        //last run data is absent, calculate from fromDate
        var checkDate = DateTime.fromMillisecondsSinceEpoch(
          habit.fromDate.millisecondsSinceEpoch,
          isUtc: false,
        );
        while (!checkDate.isAfter(today.add(Duration(days: 1)))) {
          if (checkDate.isAtSameMomentAs(checkFor)) {
            return true;
          }

          checkDate = checkDate.add(Duration(days: habit.repDuation));
        }

        return false;
      }
    }
  }

  Future<bool> deleteHabit(int habitId) async {
    await this.hmp.delete(habitId);
    await this.rdp.deleteData(habitId);
    await this.lrdp.deleteData(habitId);
    return true;
  }
}
