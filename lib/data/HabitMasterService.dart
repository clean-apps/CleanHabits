import 'package:CleanHabits/data/domain/HabitMaster.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/widgets/new/SelectChecklistType.dart';
import 'package:CleanHabits/widgets/new/SelectRepeat.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:flutter/material.dart';

class HabitMasterService {
  //
  var hmp = ProviderFactory.habitMasterProvider;
  //
  Future<List<Habit>> list(DateTime target) async {
    if (target.difference(DateTime.now()).inDays < 0) {
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

      return new Future.delayed(
        const Duration(seconds: 3),
        () => habits,
      );
    } else {
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
  }

  Future<Habit> create({
    String title,
    Repeats repeat,
    DateTime fromDate,
    ChecklistType type,
    TimeOfDay reminder,
    String timeOfDay,
  }) async {
    //
    var data = HabitMaster.fromDomain(
      title,
      repeat,
      fromDate,
      type,
      reminder,
      timeOfDay,
    );
    return await this.hmp.insert(data).then((data) => data.toDomain());
  }

  Future<bool> updateStatus({Habit habit, DateTime dateTime}) async {
    //
    return new Future.delayed(
      const Duration(seconds: 3),
      () => true,
    );
  }
}
