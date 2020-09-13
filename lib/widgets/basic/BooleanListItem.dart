import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:flutter/material.dart';

class BooleanListItem extends StatefulWidget {
  final Habit habit;
  final DateTime date;
  final HabitMasterService habitMaster = new HabitMasterService();
  BooleanListItem({this.habit, this.date});

  @override
  _BooleanListItemState createState() => _BooleanListItemState();
}

class _BooleanListItemState extends State<BooleanListItem> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  String toReminderString(TimeOfDay tod) {
    if (tod == null) {
      return '';
    } else {
      var _hour = tod.hour.toString().padLeft(2, '0');
      var _minute = tod.minute.toString().padLeft(2, '0');
      return "$_hour:$_minute";
    }
  }

  String _getReminder() {
    var now = DateTime.now();
    var nowHour = (now.hour + now.minute / 60.0);
    this.widget.habit.reminder.sort(
          (a, b) =>
              (a.hour + a.minute / 60.0).compareTo((b.hour + b.minute / 60.0)),
        );
    var thatReminder = this.widget.habit.reminder.firstWhere(
          (rem) => (rem.hour + rem.minute / 60.0) > nowHour,
          orElse: () => null,
        );

    return thatReminder == null ? null : toReminderString(thatReminder);
  }

  @override
  Widget build(BuildContext context) {
    //
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;
    var subtitleStyle = Theme.of(context).textTheme.subtitle2;

    var backgroundColor = widget.habit == null || widget.habit.ynCompleted
        ? _theme.primaryColor.withAlpha(_darkMode ? 75 : 10)
        : _darkMode
            ? _theme.textTheme.subtitle2.color.withAlpha(50)
            : _theme.scaffoldBackgroundColor;

    var borderColor = widget.habit == null || widget.habit.ynCompleted
        ? _theme.primaryColor.withAlpha(80)
        : _theme.textTheme.subtitle2.color.withAlpha(_darkMode ? 100 : 50);

    var _icon = widget.habit == null || widget.habit.ynCompleted
        ? Icon(Icons.check_circle,
            size: 40.0, color: Theme.of(context).accentColor)
        : Icon(
            Icons.panorama_fish_eye,
            size: 40.0,
            color: Theme.of(context).primaryColor.withAlpha(200),
          );

    var displayReminder = _getReminder();

    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      padding: const EdgeInsets.only(top: 5.0, left: 5.0, bottom: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: ListTile(
        dense: true,
        title: Hero(
          tag: 'habit-title-' + this.widget.habit.id.toString(),
          child: Text(
            this.widget.habit.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        subtitle: Row(
          children: [
            this.widget.habit.reminder == null ||
                    this.widget.habit.reminder.length == 0
                ? Text(
                    this.widget.habit.timeOfDay == null
                        ? 'All Day'
                        : this.widget.habit.timeOfDay,
                    style: subtitleStyle,
                  )
                : displayReminder == null
                    ? Container()
                    : Row(
                        children: [
                          _getReminder() == null
                              ? null
                              : Icon(
                                  Icons.alarm,
                                  color: subtitleStyle.color,
                                  size: subtitleStyle.fontSize,
                                ),
                          Text(_getReminder(), style: subtitleStyle)
                        ],
                      ),
            this.widget.habit.isSkipped
                ? Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Skipped',
                      style: subtitleStyle,
                    ),
                  )
                : Container()
          ],
        ),
        trailing: loading
            ? IconButton(
                icon: CircularProgressIndicator(),
                onPressed: () => {},
              )
            : IconButton(
                icon: _icon,
                padding: EdgeInsets.all(0.0),
                onPressed: () => {
                  setState(() {
                    loading = true;
                    widget.habit.ynCompleted = !widget.habit.ynCompleted;
                    widget.habit.isSkipped = false;
                  }),
                  widget.habitMaster
                      .updateStatus(habit: widget.habit, dateTime: widget.date)
                      .then(
                        (sts) => setState(() {
                          loading = false;
                        }),
                      )
                },
              ),
        onTap: () => Navigator.pushNamed(
          context,
          '/habit/progress',
          arguments: this.widget.habit,
        ),
      ),
    );
  }
}
