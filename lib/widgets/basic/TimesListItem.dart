import 'package:CleanHabits/domain/Habit.dart';
import 'package:flutter/material.dart';

class TimesListItem extends StatelessWidget {
  final Habit habit;
  final DateTime date;
  TimesListItem({this.habit, this.date});

  @override
  Widget build(BuildContext context) {
    //
    var _theme = Theme.of(context);
    var subtitleStyle = _theme.textTheme.subtitle2;

    var timesProgress = this.habit.timesProgress;
    var timesTarget = this.habit.timesTarget;
    var timesTargetType = this.habit.timesTargetType;

    var backgroundColor = timesProgress == timesTarget
        ? _theme.primaryColor.withAlpha(10)
        : _theme.scaffoldBackgroundColor;

    var borderColor = timesProgress == timesTarget
        ? _theme.primaryColor.withAlpha(80)
        : _theme.textTheme.subtitle2.color.withAlpha(50);

    var _addIcon = Icon(
      Icons.keyboard_arrow_up,
      color: _theme.primaryColor.withAlpha(200),
    );

    var _minusIcon = Icon(
      Icons.keyboard_arrow_down,
      color: _theme.primaryColor.withAlpha(200),
    );

    var _progressIcon = CircularProgressIndicator(
      backgroundColor: _theme.textTheme.subtitle2.color.withAlpha(25),
      value: this.habit.timesProgress / this.habit.timesTarget,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: ListTile(
        dense: false,
        isThreeLine: true,
        title: Hero(
          tag: 'habit-title-' + this.habit.id.toString(),
          child: Text(this.habit.title,
              style: Theme.of(context).textTheme.headline6),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                "${timesProgress.toString()}/${timesTarget.toString()} $timesTargetType Completed",
                style: subtitleStyle),
            Text(this.habit.reminder, style: subtitleStyle),
          ],
        ),
        trailing: Wrap(
          children: <Widget>[
            IconButton(
              icon: _addIcon,
              onPressed: () => debugPrint('habbit marked completed'),
            ),
            IconButton(
              icon: _minusIcon,
              onPressed: () => debugPrint('habbit marked completed'),
            ),
            IconButton(
              icon: _progressIcon,
              onPressed: () => null,
            ),
          ],
        ),
        onTap: () => Navigator.pushNamed(
          context,
          '/habit/progress',
          arguments: this.habit,
        ),
      ),
    );
  }
}
