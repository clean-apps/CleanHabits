import 'package:CleanHabits/data/HabitStatsService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/BasicTile.dart';
import 'package:flutter/material.dart';

class HabitStatusSummary extends StatefulWidget {
  final Habit habit;
  final HabitStatsService habitStats = new HabitStatsService();
  HabitStatusSummary({this.habit});

  @override
  _HabitStatusSummaryState createState() => _HabitStatusSummaryState();
}

class _HabitStatusSummaryState extends State<HabitStatusSummary> {
  HabitStatus status = HabitStatus();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    //
    widget.habitStats
        .getStatusSummary(widget.habit)
        .then((value) => setState(() {
              status = value;
              loading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    var descCurrentStreak = loading
        ? ''
        : status.currentStreak > 0
            ? 'Let\'s keep this tempo going'
            : 'Now is a good time to start';

    var descWeeklyGoal = loading
        ? ''
        : status.weekProgress > 0
            ? status.weekProgress == status.weekTarget
                ? 'Great, target completed'
                : 'Good, target is in-progress'
            : 'Start for your goals now';

    return Row(
      children: <Widget>[
        BasicTile(
          title: loading ? '0' : '${status.currentStreak.toString()}',
          subtitle1: 'Current Streak',
          subtitle2: descCurrentStreak,
        ),
        BasicTile(
          title: loading
              ? '0'
              : '${status.weekProgress.toString()}/${status.weekTarget.toString()}',
          subtitle1: 'Weekly Goal',
          subtitle2: descWeeklyGoal,
        )
      ],
    );
  }
}

class HabitStatus {
  final int currentStreak;
  final int weekProgress;
  final int weekTarget;

  HabitStatus({
    this.currentStreak = 0,
    this.weekProgress = 0,
    this.weekTarget = 0,
  });
}
