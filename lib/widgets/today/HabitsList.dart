import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/BooleanListItem.dart';
import 'package:CleanHabits/widgets/basic/TimesListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HabitsList extends StatelessWidget {
  //
  final List<Habit> habits;
  final DateTime date;
  HabitsList({this.habits, this.date});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: new SliverChildListDelegate(
        habits
            .asMap()
            .entries
            .map(
              (entry) => AnimationConfiguration.staggeredList(
                position: entry.key,
                duration: const Duration(milliseconds: 1000),
                child: FadeInAnimation(
                  child: entry.value.isYNType
                      ? BooleanListItem(habit: entry.value, date: this.date)
                      : TimesListItem(habit: entry.value, date: this.date),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
