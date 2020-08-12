import 'package:CleanHabits/data/HabitStatsService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/HeatMap.dart';
import 'package:flutter/material.dart';

class HabitHeatMap extends StatefulWidget {
  final Habit habit;
  final HabitStatsService habitStats = new HabitStatsService();
  HabitHeatMap({this.habit});

  @override
  _HabitHeatMapState createState() => _HabitHeatMapState();
}

class _HabitHeatMapState extends State<HabitHeatMap> {
  Map<DateTime, int> data = Map();
  bool loading = true;
  //
  var type = "Show All";

  @override
  void initState() {
    super.initState();
    type = "Show All";
    _loadData();
  }

  void _loadData() {
    widget.habitStats.getHeatMapData(widget.habit).then(
          (value) => setState(() {
            data = value;
            loading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      data: data,
      type: type,
      loading: loading,
      onFilter: (type) => {
        setState(() {
          type = type;
          loading = true;
        }),
        _loadData(),
      },
    );
  }
}
