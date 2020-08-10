class Habit {
  int id;
  String title;
  String reminder;

  bool isYNType;
  bool ynCompleted;

  int timesTarget;
  int timesProgress;
  String timesTargetType;

  static Habit newYNHabit({
    int id,
    String title,
    String reminder,
    bool completed,
  }) {
    Habit newHabit = new Habit();
    newHabit.id = id;
    newHabit.title = title;
    newHabit.reminder = reminder;
    newHabit.isYNType = true;
    newHabit.ynCompleted = completed;
    newHabit.timesTarget = 1;
    newHabit.timesProgress = completed ? 1 : 0;
    newHabit.timesTargetType = null;

    return newHabit;
  }

  static Habit newTimesHabit({
    int id,
    String title,
    String reminder,
    int target,
    int completed,
    String targetType,
  }) {
    Habit newHabit = new Habit();
    newHabit.id = id;
    newHabit.title = title;
    newHabit.reminder = reminder;
    newHabit.isYNType = false;
    newHabit.ynCompleted = completed == target;
    newHabit.timesTarget = target;
    newHabit.timesProgress = completed;
    newHabit.timesTargetType = targetType;

    return newHabit;
  }
}
