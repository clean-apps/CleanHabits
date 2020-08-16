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
  Habit habit;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    habit = widget.habit;
  }

  @override
  Widget build(BuildContext context) {
    //
    var subtitleStyle = Theme.of(context).textTheme.subtitle2;

    var backgroundColor = this.habit == null || this.habit.ynCompleted
        ? Theme.of(context).primaryColor.withAlpha(10)
        : Theme.of(context).scaffoldBackgroundColor;

    var borderColor = this.habit == null || this.habit.ynCompleted
        ? Theme.of(context).primaryColor.withAlpha(80)
        : Theme.of(context).textTheme.subtitle2.color.withAlpha(50);

    var _icon = this.habit == null || this.habit.ynCompleted
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
                    habit.ynCompleted = !habit.ynCompleted;
                  }),
                  widget.habitMaster
                      .updateStatus(habit: habit, dateTime: widget.date)
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
