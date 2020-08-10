import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/HeatMap.dart';
import 'package:flutter/material.dart';
import 'package:heatmap_calendar/time_utils.dart';
import 'dart:math';

class HabitHeatMap extends StatefulWidget {
  final Habit habit;
  HabitHeatMap({this.habit});

  @override
  _HabitHeatMapState createState() => _HabitHeatMapState();
}

class _HabitHeatMapState extends State<HabitHeatMap> {
  Map<DateTime, int> data = Map();
  var type = "Show All";

  @override
  void initState() {
    super.initState();
    data = _getData();
    type = "Show All";
  }

  Map<DateTime, int> _getData() {
    var rng = new Random();
    return {
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
  }

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      data: data,
      type: type,
      onFilter: (type) => debugPrint('daily tracker filtered by $type'),
    );
  }
}
