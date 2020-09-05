import 'package:CleanHabits/data/domain/HabitMaster.dart';
import 'package:CleanHabits/data/provider/WeekDateProvider.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:intl/intl.dart';

final String tableHabitRunData = 'habit_run_data';

final String columnId = '_id';
final String columnHabitId = '_habit_id';

final String columnTargetDate = 'target_date'; // unix epoch

final String columnTargetWeekInYear = 'target_week_in_year';
final String columnTargetWeekInYearWMon = 'target_week_in_year_w_mon';
final String columnTargetWeekInYearWSun = 'target_week_in_year_w_sun';
final String columnTargetMonthInYear = 'target_mon_in_year';
final String columnTargetDayInWeek = 'target_day_in_week';

final String columnTarget = 'target';
final String columnProgress = 'progress';

final String columnCurrentStreak = '_current_streak';
final String columnStreakStartDate = '_streak_start_date';
final String columnHasStreakEnded = '_has_streak_ended';

final String columnHasSkipped = 'has_skipped';

final String columnPrevRunDate = 'prev_run_date'; // unix epoch

var fmtDay = DateFormat("D");
var fmMonth = DateFormat("MMM");
var fmtDayOfWeek = DateFormat("E");

int weekNumberWMon(DateTime date) {
  return WeekDateProvider.weekOfYear(date: date, startWithMonday: true);
}

int weekNumberWSun(DateTime date) {
  return WeekDateProvider.weekOfYear(date: date, startWithMonday: false);
}

String getMonth(DateTime date) {
  return fmMonth.format(date);
}

class HabitRunData {
  int id;
  int habitId;
  DateTime targetDate;

  String dayName;
  String weekNoWMon;
  String weekNoWSun;
  String monthName;

  int target;
  int progress;

  int currentStreak = 0;
  DateTime streakStartDate;
  bool hasStreakEnded;
  DateTime prevRunDate;

  bool hasSkipped;

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
    data.prevRunDate = null;
    data.hasSkipped = false;
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
    data.prevRunDate = null;
    data.hasSkipped = false;
    return data;
  }

  Habit toDomain(Habit habit) {
    //
    habit.timesProgress = this.progress;
    habit.ynCompleted = this.progress == habit.timesTarget;
    habit.isSkipped = this.hasSkipped;

    return habit;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnHabitId: habitId,
      columnTargetDate:
          targetDate == null ? null : targetDate.millisecondsSinceEpoch,
      columnTargetDayInWeek:
          targetDate == null ? null : fmtDayOfWeek.format(targetDate),
      columnTargetWeekInYearWMon:
          targetDate == null ? null : 'W${weekNumberWMon(targetDate)}',
      columnTargetWeekInYearWSun:
          targetDate == null ? null : 'W${weekNumberWSun(targetDate)}',
      columnTargetMonthInYear: targetDate == null ? null : getMonth(targetDate),
      columnTarget: target == null ? null : target.toString(),
      columnProgress: progress == null ? null : progress.toString(),
      columnCurrentStreak: currentStreak,
      columnStreakStartDate: streakStartDate == null
          ? null
          : streakStartDate.millisecondsSinceEpoch,
      columnHasStreakEnded:
          hasStreakEnded == null ? null : (hasStreakEnded ? 1 : 0),
      columnPrevRunDate:
          prevRunDate == null ? null : prevRunDate.millisecondsSinceEpoch,
      columnHasSkipped: hasSkipped ? 1 : 0,
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

    dayName = map[columnTargetDayInWeek];
    weekNoWMon = map[columnTargetWeekInYearWMon];
    weekNoWSun = map[columnTargetWeekInYearWSun];
    monthName = map[columnTargetMonthInYear];

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
    prevRunDate = map[columnPrevRunDate] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
            map[columnPrevRunDate],
            isUtc: false,
          );
    hasSkipped = map[columnHasSkipped] == 1;
  }
}
