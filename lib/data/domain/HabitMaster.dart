import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/new/SelectChecklistType.dart';
import 'package:CleanHabits/widgets/new/SelectRepeat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final String tableHabitMaster = 'habit_master';

final String columnId = '_id';
final String columnTitle = 'title';
final String columnReminder = 'reminder';

final String columnFromDate = 'from_date'; // unix epoc
final String columnTimeOfDay = 'time_of_day';

final String columnRepIsNone = 'rep_is_none';
final String columnRepIsWeekly = 'rep_is_weekly';
final String columnRepInSun = 'rep_in_sun';
final String columnRepInMon = 'rep_in_mon';
final String columnRepInTue = 'rep_in_tue';
final String columnRepInWed = 'rep_in_wed';
final String columnRepInThu = 'rep_in_thu';
final String columnRepInFri = 'rep_in_fri';
final String columnRepInSat = 'rep_in_sat';
final String columnRepDuration = 'rep_duration';

final String columnISYNType = 'is_yn_type';
final String columnTimesTarget = 'times_target';
final String columnTimesTargetType = 'times_target_type';

var fmt = DateFormat("HH:mm");

class HabitMaster {
  int id;
  String title;
  TimeOfDay reminder;

  DateTime fromDate;
  String timeOfDay;

  bool isNone;
  bool isWeekly;
  bool hasSun;
  bool hasMon;
  bool hasTue;
  bool hasWed;
  bool hasThu;
  bool hasFri;
  bool hasSat;
  int repDuation;

  bool isYNType;
  int timesTarget;
  String timesTargetType;

  static HabitMaster fromDomain(
    String title,
    Repeats repeat,
    DateTime fromDate,
    ChecklistType type,
    TimeOfDay reminder,
    String timeOfDay,
  ) {
    //
    var data = HabitMaster();
    data.title = title;
    data.reminder = reminder;
    data.fromDate = fromDate;
    data.timeOfDay = timeOfDay;

    data.isNone = repeat.none;
    data.isWeekly = repeat.isWeekly;
    data.hasSun = repeat.hasSun;
    data.hasMon = repeat.hasMon;
    data.hasTue = repeat.hasTue;
    data.hasWed = repeat.hasWed;
    data.hasThu = repeat.hasThu;
    data.hasFri = repeat.hasFri;
    data.hasSat = repeat.hasSat;
    data.repDuation = repeat.interval;

    data.isYNType = type.isSimple;
    data.timesTarget = type.isSimple ? 1 : type.times;
    data.timesTargetType = type.timesType;

    return data;
  }

  Habit toDomain() {
    var data = Habit();
    data.id = this.id;
    data.title = this.title;
    data.reminder = this.reminderString;
    data.isYNType = this.isYNType;
    data.timesTarget = this.isYNType ? 1 : this.timesTarget;
    data.timesTargetType = this.timesTargetType;
    data.timeOfDay = this.timeOfDay;

    return data;
  }

  String get reminderString {
    final now = new DateTime.now();
    final dt = reminder == null
        ? null
        : DateTime(
            now.year,
            now.month,
            now.day,
            reminder.hour,
            reminder.minute,
          );

    return dt == null ? null : fmt.format(dt);
  }

  Map<String, dynamic> toMap() {
    final now = new DateTime.now();
    final dt = reminder == null
        ? null
        : DateTime(
            now.year,
            now.month,
            now.day,
            reminder.hour,
            reminder.minute,
          );

    var map = <String, dynamic>{
      columnTitle: title,
      columnReminder: dt == null ? null : dt.millisecondsSinceEpoch,
      //
      columnFromDate: fromDate == null ? null : fromDate.millisecondsSinceEpoch,
      columnTimeOfDay: timeOfDay,
      //
      columnRepIsNone: isNone == true ? 1 : 0,
      columnRepIsWeekly: isWeekly == true ? 1 : 0,
      columnRepInSun: hasSun == true ? 1 : 0,
      columnRepInMon: hasMon == true ? 1 : 0,
      columnRepInTue: hasTue == true ? 1 : 0,
      columnRepInWed: hasWed == true ? 1 : 0,
      columnRepInThu: hasThu == true ? 1 : 0,
      columnRepInFri: hasFri == true ? 1 : 0,
      columnRepInSat: hasSat == true ? 1 : 0,
      columnRepDuration: repDuation,
      //
      columnISYNType: isYNType == true ? 1 : 0,
      columnTimesTarget: timesTarget == null ? null : timesTarget.toString(),
      columnTimesTargetType: timesTargetType
    };

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }

  HabitMaster();

  HabitMaster.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    reminder = map[columnReminder] == null
        ? null
        : TimeOfDay.fromDateTime(
            DateTime.fromMillisecondsSinceEpoch(
              map[columnReminder],
              isUtc: false,
            ),
          );
    //
    fromDate = map[columnFromDate] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            map[columnFromDate],
            isUtc: false,
          );
    timeOfDay = map[columnTimeOfDay];

    isNone = map[columnRepIsNone] == 1;
    isWeekly = map[columnRepIsWeekly] == 1;
    hasSun = map[columnRepInSun] == 1;
    hasMon = map[columnRepInMon] == 1;
    hasTue = map[columnRepInTue] == 1;
    hasWed = map[columnRepInWed] == 1;
    hasThu = map[columnRepInThu] == 1;
    hasFri = map[columnRepInFri] == 1;
    hasSat = map[columnRepInSat] == 1;
    repDuation = map[columnRepDuration];
    //
    isYNType = map[columnISYNType] == 1;
    timesTarget =
        map[columnTimesTarget] == null ? null : map[columnTimesTarget];
    timesTargetType = map[columnTimesTargetType];
  }
}
