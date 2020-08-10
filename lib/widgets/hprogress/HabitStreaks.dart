import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/StackedBarChart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HabitStreaks extends StatefulWidget {
  final Habit habit;
  HabitStreaks({this.habit});

  @override
  _HabitStreaksState createState() => _HabitStreaksState();
}

class _HabitStreaksState extends State<HabitStreaks> {
  List<StackData> data = List();

  @override
  void initState() {
    super.initState();
    data = _getData();
  }

  List<StackData> _getData() {
    var rng = new Random();
    return [
      new StackData('Nov 11', 'Nov 12', rng.nextInt(25)),
      new StackData('Nov 12', 'Nov 13', rng.nextInt(25)),
      new StackData('Nov 13', 'Nov 14', rng.nextInt(25)),
      new StackData('Nov 14', 'Nov 15', rng.nextInt(25)),
      new StackData('Nov 15', 'Nov 16', rng.nextInt(25)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      ListTile(
        title: Text(
          'Best Streaks',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      StackedBarChart(data: data)
    ];

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
      ),
    );
  }
}
