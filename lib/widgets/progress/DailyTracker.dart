import 'package:CleanHabits/widgets/basic/HeatMap.dart';
import 'package:flutter/widgets.dart';
import 'package:heatmap_calendar/time_utils.dart';
import 'dart:math';

class DailyTracker extends StatefulWidget {
  @override
  _DailyTrackerState createState() => _DailyTrackerState();
}

class _DailyTrackerState extends State<DailyTracker> {
  Map<DateTime, int> data = Map();
  var type = "Show All";

  @override
  void initState() {
    super.initState();
    //
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

  onFilter(type) {
    debugPrint('daily tracker changed to type $type');
  }

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      data: data,
      type: type,
      onFilter: (type) => onFilter(type),
    );
  }
}
