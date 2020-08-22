class Habit {
  int id;
  String title;
  String reminder;

  bool isYNType;
  bool ynCompleted;

  int timesTarget;
  int timesProgress;
  String timesTargetType;

  String timeOfDay;

  bool isFailed;
  bool isSkipped;

  static Habit newYNHabit({
    int id,
    String title,
    String reminder,
    bool completed,
    String timeOfDay,
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
    newHabit.timeOfDay = timeOfDay;
    newHabit.isFailed = false;
    newHabit.isSkipped = false;

    return newHabit;
  }

  static Habit newTimesHabit({
    int id,
    String title,
    String reminder,
    int target,
    int completed,
    String targetType,
    String timeOfDay,
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
    newHabit.timeOfDay = timeOfDay;
    newHabit.isFailed = false;
    newHabit.isSkipped = false;

    return newHabit;
  }

  @override
  String toString() {
    return '[$id] $title -> isSimple: $isYNType -> progress: $timesProgress -> ynCompleted: $ynCompleted';
  }
}
