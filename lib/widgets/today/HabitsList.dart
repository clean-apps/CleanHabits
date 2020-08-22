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

  Widget _emptyList(context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(30),
              child: Image.asset(
                'assets/no-habits.png',
              ),
            ),
            Text(
              'Empty List',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Click on the new button',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text(
              ' to add a habit',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return habits.length == 0
        ? SliverList(
            delegate: new SliverChildListDelegate(
            [_emptyList(context)],
          ))
        : SliverList(
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
                            ? BooleanListItem(
                                habit: entry.value,
                                date: this.date,
                              )
                            : TimesListItem(
                                habit: entry.value,
                                date: this.date,
                              ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
  }
}
