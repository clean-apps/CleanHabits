import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/BooleanListItem.dart';
import 'package:CleanHabits/widgets/basic/TimesListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HabitsList extends StatefulWidget {
  //
  final DateTime date;
  HabitsList({this.date});

  @override
  _HabitsListState createState() => _HabitsListState();
}

class _HabitsListState extends State<HabitsList> {
  List<Habit> habits = List();

  @override
  void initState() {
    super.initState();
    //
    habits = _getData();
  }

  List<Habit> _getData() {
    var habits = new List<Habit>();
    habits.add(Habit.newYNHabit(
      id: 1,
      title: "Morning Job",
      reminder: "06:00 AM",
      completed: false,
    ));
    habits.add(Habit.newYNHabit(
      id: 2,
      title: "Eat Healthy",
      reminder: "08:00 AM",
      completed: false,
    ));
    habits.add(Habit.newYNHabit(
      id: 3,
      title: "Get Up Early",
      reminder: "06:00 AM",
      completed: true,
    ));
    habits.add(Habit.newTimesHabit(
      id: 4,
      title: "Read 20 Pages",
      reminder: "06:00 AM",
      completed: 14,
      target: 20,
      targetType: "Pages",
    ));
    habits.add(Habit.newYNHabit(
      id: 5,
      title: "Learn A New Word",
      reminder: "09:00 AM",
      completed: true,
    ));

    return habits;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      initialItemCount: habits.length,
      itemBuilder: (context, index, anim) =>
          AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 1000),
        child: FadeInAnimation(
          child: habits[index].isYNType
              ? BooleanListItem(habit: habits[index], date: widget.date)
              : TimesListItem(habit: habits[index], date: widget.date),
        ),
      ),
    );
  }
}
