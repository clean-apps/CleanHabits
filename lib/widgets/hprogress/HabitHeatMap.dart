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
    widget.habitStats.getHeatMapData(widget.habit, type).then(
          (value) => setState(() {
            this.data = value;
            this.loading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      data: this.data,
      type: this.type,
      loading: this.loading,
      onFilter: (pType) => {
        setState(() {
          this.type = pType;
          this.loading = true;
        }),
        _loadData(),
      },
    );
  }
}
