import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/new/SelectChecklistType.dart';
import 'package:CleanHabits/widgets/new/SelectRepeat.dart';
import 'package:flutter/material.dart';

class HabitMasterService {
  //
  Future<List<Habit>> list(DateTime target) async {
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

    return new Future.delayed(
      const Duration(seconds: 3),
      () => habits,
    );
  }

  Future<bool> create({
    String title,
    Repeats repeat,
    DateTime fromDate,
    ChecklistType type,
    TimeOfDay reminder,
    String timeOfDay,
  }) async {
    //
    return new Future.delayed(
      const Duration(seconds: 3),
      () => true,
    );
  }

  Future<bool> updateStatus({Habit habit, DateTime dateTime}) async {
    //
    return new Future.delayed(
      const Duration(seconds: 3),
      () => true,
    );
  }
}
