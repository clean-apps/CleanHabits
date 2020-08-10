import 'package:CleanHabits/widgets/hprogress/HabitCompletionRate.dart';
import 'package:CleanHabits/widgets/hprogress/HabitHeatMap.dart';
import 'package:CleanHabits/widgets/hprogress/HabitStatusSummary.dart';
import 'package:CleanHabits/widgets/hprogress/HabitStreaks.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HabitProgress extends StatelessWidget {
  final int index = 1;

  AppBar _appBar(BuildContext context, Habit habit) {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;

    return new AppBar(
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: accentColor),
      title: Hero(
        tag: 'habit-title-' + habit.id.toString(),
        child: Text(
          habit.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Habit habit = ModalRoute.of(context).settings.arguments;

    var _widgetList = <Widget>[
      HabitStatusSummary(habit: habit),
      HabitCompletionRate(habit: habit),
      HabitStreaks(habit: habit),
      HabitHeatMap(habit: habit),
    ];

    return new Scaffold(
      appBar: _appBar(context, habit),
      body: Container(
        color: Colors.grey.withOpacity(0.05),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAnimatedList(
              initialItemCount: _widgetList.length,
              itemBuilder: (context, index, anim) =>
                  AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: FadeInAnimation(child: _widgetList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
