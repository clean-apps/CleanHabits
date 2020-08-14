import 'dart:math';

import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/BarChart.dart';
import 'package:CleanHabits/widgets/basic/LineChart.dart';
import 'package:CleanHabits/widgets/progress/StatusSummary.dart';
import 'package:heatmap_calendar/time_utils.dart';

class ProgressStatsService {
  //
  Future<List<LinearData>> getCompletionRateData(String type) {
    var rng = new Random();
    var data = [
      new LinearData('W21', 1, rng.nextInt(25)),
      new LinearData('W22', 2, rng.nextInt(25)),
      new LinearData('W23', 3, rng.nextInt(25)),
      new LinearData('W24', 4, rng.nextInt(25)),
      new LinearData('W25', 5, rng.nextInt(25)),
      new LinearData('W26', 6, rng.nextInt(25)),
      new LinearData('W27', 7, rng.nextInt(25)),
      new LinearData('W28', 8, rng.nextInt(25)),
      new LinearData('W29', 9, rng.nextInt(25)),
      new LinearData('W30', 10, rng.nextInt(25)),
    ];
    return new Future.delayed(
      const Duration(seconds: 3),
      () => data,
    );
  }

  Future<List<Habit>> getWeeklyProgressData() {
    var weeklyData = new List<Habit>();
    weeklyData.add(Habit.newTimesHabit(
      id: 1,
      title: "Morning Job",
      completed: 14,
      target: 20,
    ));
    weeklyData.add(Habit.newTimesHabit(
      id: 2,
      title: "Eat Healthy",
      completed: 14,
      target: 20,
    ));
    weeklyData.add(Habit.newTimesHabit(
      id: 3,
      title: "Get Up Early",
      completed: 14,
      target: 20,
    ));
    // weeklyData.add(Habit.newTimesHabit(
    //   id: 4,
    //   title: "Read 20 Pages",
    //   completed: 14,
    //   target: 20,
    // ));
    // weeklyData.add(Habit.newTimesHabit(
    //   id: 5,
    //   title: "Learn A New Word",
    //   completed: 14,
    //   target: 20,
    // ));
    return new Future.delayed(
      const Duration(seconds: 3),
      () => weeklyData,
    );
  }

  Future<StatusSummaryData> getStatusSummaryData() {
    return new Future.delayed(
      const Duration(seconds: 3),
      () => StatusSummaryData(
        todayProgress: 2,
        todayTarget: 7,
      ),
    );
  }

  Future<Map<DateTime, int>> getHeatMapData(String type) {
    var rng = new Random();
    var data = {
      TimeUtils.removeTime(DateTime.now().subtract(
        Duration(days: rng.nextInt(10)),
      )): rng.nextInt(50) + 1,
      TimeUtils.removeTime(DateTime.now().subtract(
        Duration(days: rng.nextInt(10)),
      )): rng.nextInt(50) + 1,
      TimeUtils.removeTime(DateTime.now().subtract(
        Duration(days: rng.nextInt(10)),
      )): rng.nextInt(50) + 1,
      TimeUtils.removeTime(DateTime.now().subtract(
        Duration(days: rng.nextInt(10)),
      )): rng.nextInt(50) + 1,
      TimeUtils.removeTime(DateTime.now().subtract(
        Duration(days: rng.nextInt(10)),
      )): rng.nextInt(50) + 1,
      TimeUtils.removeTime(DateTime.now()): rng.nextInt(50) + 1,
    };

    return new Future.delayed(
      const Duration(seconds: 3),
      () => data,
    );
  }

  Future<List<ChartData>> getDayWiseProgressData() {
    var rng = new Random();
    var data = [
      new ChartData('Sun', rng.nextInt(25)),
      new ChartData('Mon', rng.nextInt(25)),
      new ChartData('Tue', rng.nextInt(25)),
      new ChartData('Wed', rng.nextInt(25)),
      new ChartData('Thu', rng.nextInt(25)),
      new ChartData('Fri', rng.nextInt(25)),
      new ChartData('Sat', rng.nextInt(25)),
    ];
    return new Future.delayed(
      const Duration(seconds: 3),
      () => data,
    );
  }
}
