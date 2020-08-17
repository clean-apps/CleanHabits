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

final String columnCurrentStreak = '_current_streak';
final String columnStreakStartDate = '_streak_start_date';
final String columnHasStreakEnded = '_has_streak_ended';

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

  int currentStreak = 0;
  DateTime streakStartDate;
  bool hasStreakEnded;

  static HabitRunData withSimpleHabit(
    HabitMaster habit,
    DateTime targetDate,
    bool completed,
    int streak,
    DateTime streakStartDate,
    bool hasStreakEnded,
  ) {
    //
    var data = HabitRunData();
    data.habitId = habit.id;
    data.target = 1;
    data.progress = completed ? 1 : 0;
    data.currentStreak = streak;
    data.streakStartDate = streakStartDate;
    data.hasStreakEnded = hasStreakEnded;
    return data;
  }

  static HabitRunData withCountableHabit(
    HabitMaster habit,
    DateTime targetDate,
    int progress,
    int streak,
    DateTime streakStartDate,
    bool hasStreakEnded,
  ) {
    //
    var data = HabitRunData();
    data.habitId = habit.id;
    data.target = habit.timesTarget;
    data.progress = progress;
    data.currentStreak = streak;
    data.streakStartDate = streakStartDate;
    data.hasStreakEnded = hasStreakEnded;
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
      columnCurrentStreak: currentStreak,
      columnStreakStartDate: streakStartDate == null
          ? null
          : streakStartDate.millisecondsSinceEpoch,
      columnHasStreakEnded:
          hasStreakEnded == null ? null : (hasStreakEnded ? 1 : 0)
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
    currentStreak = map[columnCurrentStreak];
    streakStartDate = map[columnStreakStartDate] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            map[columnStreakStartDate],
            isUtc: false,
          );
    hasStreakEnded = map[columnHasStreakEnded] == null
        ? null
        : map[columnHasStreakEnded] == 1;
  }
}
