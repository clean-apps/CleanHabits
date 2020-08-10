import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/BasicTile.dart';
import 'package:flutter/material.dart';

class HabitStatusSummary extends StatefulWidget {
  final Habit habit;
  HabitStatusSummary({this.habit});

  @override
  _HabitStatusSummaryState createState() => _HabitStatusSummaryState();
}

class _HabitStatusSummaryState extends State<HabitStatusSummary> {
  var currentStreak = 0;
  var weekProgress = 0;
  var weekTarget = 0;

  @override
  void initState() {
    super.initState();
    //
    currentStreak = 5;
    weekProgress = 2;
    weekTarget = 7;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        BasicTile(
          title: '${currentStreak.toString()}',
          subtitle1: 'Current Streak',
          subtitle2: 'cool streak description',
        ),
        BasicTile(
          title: '${weekProgress.toString()}/${weekTarget.toString()}',
          subtitle1: 'Weekly Goal',
          subtitle2: 'cool goal description',
        )
      ],
    );
  }
}
