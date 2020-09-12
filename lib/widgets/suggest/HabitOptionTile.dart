import 'package:CleanHabits/domain/TopicHabits.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HabitOptionTile extends StatelessWidget {
  final TopicHabits option;
  HabitOptionTile({this.option});

  @override
  Widget build(BuildContext context) {
    var _displayString =
        option.repeat == null ? 'Everyday' : option.repeat.displayString2();

    return option.isYNType
        ? ListTile(
            leading: FaIcon(option.icon, size: 36),
            title: Text(
              option.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: _displayString == null || _displayString == ''
                ? Text('')
                : Text(_displayString),
            onTap: () => Navigator.pushNamed(
              context,
              "/new",
              arguments: option,
            ),
          )
        : ListTile(
            leading: FaIcon(option.icon, size: 36),
            title: Text(
              option.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                "${option.timesTarget} ${option.timesTargetType} $_displayString"),
            onTap: () => Navigator.pushNamed(
              context,
              "/new",
              arguments: option,
            ),
          );
  }
}
