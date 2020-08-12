import 'dart:math';

import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/BarChart.dart';
import 'package:CleanHabits/widgets/basic/StackedBarChart.dart';
import 'package:CleanHabits/widgets/hprogress/HabitStatusSummary.dart';
import 'package:heatmap_calendar/time_utils.dart';

class HabitStatsService {
  Future<HabitStatus> getStatusSummary(Habit habit) {
    //
    return new Future.delayed(
      const Duration(seconds: 3),
      () => HabitStatus(
        currentStreak: 5,
        weekProgress: 2,
        weekTarget: 7,
      ),
    );
  }

  //
  Future<List<ChartData>> getCompletionRate(Habit habit, String type) {
    //
    var rng = new Random();
    return new Future.delayed(
      const Duration(seconds: 3),
      () => [
        new ChartData('W21', rng.nextInt(25)),
        new ChartData('W22', rng.nextInt(25)),
        new ChartData('W23', rng.nextInt(25)),
        new ChartData('W24', rng.nextInt(25)),
        new ChartData('W25', rng.nextInt(25)),
        new ChartData('W26', rng.nextInt(25)),
        new ChartData('W27', rng.nextInt(25)),
        new ChartData('W28', rng.nextInt(25)),
        new ChartData('W29', rng.nextInt(25)),
        new ChartData('W30', rng.nextInt(25)),
      ],
    );
  }

  //
  Future<List<StackData>> getStreaks(Habit habit) {
    //
    var rng = new Random();
    return new Future.delayed(
      const Duration(seconds: 3),
      () => [
        new StackData('Nov 11', 'Nov 12', rng.nextInt(25)),
        new StackData('Nov 12', 'Nov 13', rng.nextInt(25)),
        new StackData('Nov 13', 'Nov 14', rng.nextInt(25)),
        new StackData('Nov 14', 'Nov 15', rng.nextInt(25)),
        new StackData('Nov 15', 'Nov 16', rng.nextInt(25)),
      ],
    );
  }

  //
  Future<Map<DateTime, int>> getHeatMapData(Habit habit) {
    //
    var rng = new Random();
    Map<DateTime, int> data = {
      TimeUtils.removeTime(DateTime.now().subtract(
        Duration(days: rng.nextInt(10)),
      )): rng.nextInt(5) + 1,
      TimeUtils.removeTime(DateTime.now().subtract(
        Duration(days: rng.nextInt(10)),
      )): rng.nextInt(5) + 1,
      TimeUtils.removeTime(DateTime.now().subtract(
        Duration(days: rng.nextInt(10)),
      )): rng.nextInt(5) + 1,
      TimeUtils.removeTime(DateTime.now().subtract(
        Duration(days: rng.nextInt(10)),
      )): rng.nextInt(5) + 1,
      TimeUtils.removeTime(DateTime.now().subtract(
        Duration(days: rng.nextInt(10)),
      )): rng.nextInt(5) + 1,
      TimeUtils.removeTime(DateTime.now()): rng.nextInt(50) + 1,
    };
    //
    return new Future.delayed(
      const Duration(seconds: 3),
      () => data,
    );
  }
}
