import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/data/domain/HabitRunData.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/data/provider/WeekDateProvider.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/BarChart.dart';
import 'package:CleanHabits/widgets/basic/StackedBarChart.dart';
import 'package:CleanHabits/widgets/hprogress/HabitStatusSummary.dart';
import 'package:intl/intl.dart';

class HabitStatsService {
  //
  var hmp = ProviderFactory.habitMasterProvider;
  var lrdp = ProviderFactory.habitLastRunDataProvider;
  var rdp = ProviderFactory.habitRunDataProvider;
  var slrp = ProviderFactory.serviceLastRunProvider;
  //
  var hms = HabitMasterService();

  var fmMonth = DateFormat("MMM");
  var fmMMMdd = DateFormat("MMM dd");

  Future<HabitStatus> getStatusSummary(Habit habit) async {
    var now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    var todayRunData = await this.rdp.getData(now, habit.id);

    var sp = ProviderFactory.settingsProvider;
    var mondayStart = sp.firstDayOfWeek == 'Mon';
    var startWeek = WeekDateProvider.weekStart(
      date: now,
      startWithMonday: mondayStart,
    );

    var habitData = await this.rdp.listBetweenFor(startWeek, now, habit.id);

    var currentStreak =
        todayRunData == null || todayRunData.currentStreak == null
            ? 0
            : todayRunData.currentStreak;

    var weeklyProgress = habitData == null
        ? 0
        : habitData.map((e) => e.progress).reduce(
              (a, b) => a + b,
            );

    var weeklyTarget = habitData == null
        ? 0
        : habitData.length * (habit.isYNType ? 1 : habit.timesTarget);

    var habitMaster = await this.hmp.getData(habit.id);
    for (int cnt = 1; cnt <= (7 - now.weekday); cnt++) {
      var nextDay = now.add(Duration(days: cnt));
      if (nextDay.weekday == DateTime.sunday && mondayStart) {
        var isApplicable = await this.hms.isApplicable(habitMaster, nextDay);
        if (isApplicable) {
          weeklyTarget += (habit.isYNType ? 1 : habit.timesTarget);
        }
      }
    }

    return HabitStatus(
      currentStreak: currentStreak,
      weekProgress: weeklyProgress,
      weekTarget: weeklyTarget,
    );
  }

  //

  Future<List<ChartData>> getCompletionRate(Habit habit, String type) async {
    return type == 'Weekly'
        ? await getWeeklyCompletionRate(habit)
        : await getMonthlyCompletionRate(habit);
  }

  Future<List<ChartData>> getWeeklyCompletionRate(Habit habit) async {
    //
    var today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    var weeksToShow = 10;
    var statStart = today.subtract(Duration(days: today.weekday - 1));
    var statEnd = statStart.subtract(Duration(days: 7 * weeksToShow));
    //
    var data = List<ChartData>();
    var counts = await this.rdp.weekWiseStats(
          statStart,
          statEnd,
          habit.id,
          weeksToShow,
        );
    if (counts.length == 0) {
      return [];
    }
    if (counts.length < weeksToShow) {
      var startMarker = counts.first[columnTargetWeekInYear];
      int markerWeek = startMarker == null
          ? null
          : int.parse(startMarker.toString().substring(1));

      for (var ct = 0; ct < (weeksToShow - counts.length); ct++) {
        var weekName = markerWeek - (weeksToShow - counts.length) + ct;
        data.add(ChartData('W$weekName', 0));
      }
    }
    counts.forEach((runData) {
      data.add(
        ChartData(runData[columnTargetWeekInYear], runData['sum']),
      );
    });
    //
    return data;
  }

  Future<List<ChartData>> getMonthlyCompletionRate(Habit habit) async {
    //
    var today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    var monthsToShow = 10;

    var statStart = DateTime(today.year, today.month + 1, 1);
    var statEnd = statStart.subtract(Duration(days: 31 * monthsToShow));
    //
    var data = List<ChartData>();
    var counts = await this.rdp.weekMonthStats(
          statStart,
          statEnd,
          habit.id,
          monthsToShow,
        );
    if (counts.length == 0) {
      return [];
    }

    if (counts.length < monthsToShow) {
      var startingMonth = counts.first[columnTargetMonthInYear];
      var firstDate = fmMonth.parse(startingMonth);
      for (var ct = 0; ct < (monthsToShow - counts.length); ct++) {
        var monthToShow = firstDate.month - (monthsToShow - ct) + 1;
        var monString = fmMonth.format(DateTime(2020, monthToShow, 1));
        data.add(ChartData(monString, 0));
      }
    }
    counts.reversed.forEach((runData) {
      data.add(
        ChartData(runData[columnTargetMonthInYear], runData['sum']),
      );
    });
    //
    return data;
  }

  //
  Future<List<StackData>> getStreaks(Habit habit) async {
    //
    var maxStreaks = 5;
    var stats = await this.rdp.streaksStats(habit.id, maxStreaks);
    if (stats == null || stats.length == 0) {
      return [];
    } else {
      stats.sort(
        (pre, aft) => aft.targetDate.compareTo(pre.targetDate),
      );
      return stats
          .map((st) => new StackData(
                fmMMMdd.format(st.streakStartDate),
                fmMMMdd.format(st.targetDate),
                st.currentStreak,
              ))
          .toList();
    }
  }

  //
  Future<Map<DateTime, int>> getHeatMapData(Habit habit, String type) async {
    //
    var today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    //
    var dayToShow = 90;
    var statDate = today.subtract(Duration(days: dayToShow));
    var runData = await this.rdp.listBetweenFor(statDate, today, habit.id);

    var itrRunData = runData.map((rd) => {
          rd.targetDate:
              (rd.hasSkipped ? 0 : rd.progress) * (habit.isYNType ? 100 : 1),
        });
    var data = {
      for (var v in itrRunData) v.keys.toList()[0]: v.values.toList()[0]
    };

    return data;
  }
}
