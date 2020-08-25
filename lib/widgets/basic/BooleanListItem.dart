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
        subtitle: this.widget.habit.reminder == null
            ? Text(
                this.widget.habit.timeOfDay == null
                    ? 'All Day'
                    : this.widget.habit.timeOfDay,
                style: subtitleStyle,
              )
            : Row(
                children: [
                  Icon(
                    Icons.alarm,
                    color: subtitleStyle.color,
                    size: subtitleStyle.fontSize,
                  ),
                  Text(this.widget.habit.reminder, style: subtitleStyle)
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
