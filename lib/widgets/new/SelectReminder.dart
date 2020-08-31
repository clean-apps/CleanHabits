import 'package:CleanHabits/widgets/basic/BaseSelectionTile.dart';
import 'package:flutter/material.dart';

class SelectReminder extends StatelessWidget {
  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChange;

  SelectReminder({this.value, this.onChange});

  void _showDialog(context) {
    showTimePicker(
      initialTime: TimeOfDay.now(),
      helpText: 'Select Reminder Time',
      context: context,
    ).then(this.onChange);
  }

  @override
  Widget build(BuildContext context) {
    return BaseSelectionTile(
      value: value == null ? null : value.format(context),
      icon: Icon(Icons.notifications),
      title: 'Remind at',
      emptyText: 'No Reminder',
      onTap: () => _showDialog(context),
      onClear: () => this.onChange(null),
    );
  }
}
