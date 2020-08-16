import 'package:CleanHabits/data/domain/HabitMaster.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:intl/intl.dart';

final String tableHabitRunData = 'habit_run_data';

final String columnId = '_id';
final String columnHabitId = '_habit_id';

final String columnTargetDate = 'target_date'; // unix epoch

final String columnTargetWeekInYear = 'target_week_in_year';
final String columnTargetDayInWeek = 'target_day_in_week';

final String columnTarget = 'target';
final String columnProgress = 'progress';

var fmtDay = DateFormat("D");
var fmtDayOfWeek = DateFormat("E");

/// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
int weekNumber(DateTime date) {
  int dayOfYear = int.parse(fmtDay.format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
}

class HabitRunData {
  int id;
  int habitId;
  DateTime targetDate;

  int target;
  int progress;

  static HabitRunData withSimpleHabit(
    HabitMaster habit,
    DateTime targetDate,
    bool completed,
  ) {
    //
    var data = HabitRunData();
    data.habitId = habit.id;
    data.target = 1;
    data.progress = completed ? 1 : 0;
    return data;
  }

  static HabitRunData withCountableHabit(
    HabitMaster habit,
    DateTime targetDate,
    int progress,
  ) {
    //
    var data = HabitRunData();
    data.habitId = habit.id;
    data.target = habit.timesTarget;
    data.progress = progress;
    return data;
  }

  Habit toDomain(Habit habit) {
    habit.timesProgress = this.progress;
    habit.ynCompleted = this.progress == habit.timesTarget;

    return habit;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnHabitId: habitId,
      columnTargetDate:
          targetDate == null ? null : targetDate.millisecondsSinceEpoch,
      columnTargetWeekInYear:
          targetDate == null ? null : 'W${weekNumber(targetDate)}',
      columnTargetDayInWeek:
          targetDate == null ? null : fmtDayOfWeek.format(targetDate),
      columnTarget: target == null ? null : target.toString(),
      columnProgress: progress == null ? null : progress.toString(),
    };

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }

  HabitRunData();

  HabitRunData.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    habitId = map[columnHabitId];
    targetDate = map[columnTargetDate] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            map[columnTargetDate],
            isUtc: false,
          );

    target = map[columnTarget] == null ? null : map[columnTarget];
    progress = map[columnProgress] == null ? null : map[columnProgress];
  }
}
