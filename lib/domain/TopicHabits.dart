import 'package:CleanHabits/widgets/new/SelectRepeat.dart';
import 'package:flutter/material.dart';

class TopicHabits {
  final IconData icon;
  final String title;
  final bool isYNType;
  final int timesTarget;
  Repeats repeat = Repeats();
  final String timesTargetType;
  final String timeOfDay;

  TopicHabits({
    this.icon,
    this.title,
    this.isYNType = true,
    this.timesTarget = 1,
    this.timesTargetType = '',
    this.repeat,
    this.timeOfDay = "All Day",
  });
}
