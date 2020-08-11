import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:flutter/material.dart';

class TimesListItem extends StatefulWidget {
  final Habit habit;
  final DateTime date;
  final HabitMasterService habitMaster = new HabitMasterService();
  TimesListItem({this.habit, this.date});

  @override
  _TimesListItemState createState() => _TimesListItemState();
}

class _TimesListItemState extends State<TimesListItem> {
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
    var _theme = Theme.of(context);
    var subtitleStyle = _theme.textTheme.subtitle2;

    var timesProgress = this.habit == null ? 0 : this.habit.timesProgress;
    var timesTarget = this.habit == null ? 0 : this.habit.timesTarget;
    var timesTargetType = this.habit == null ? 0 : this.habit.timesTargetType;

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
      value: this.widget.habit.timesProgress / this.widget.habit.timesTarget,
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
          tag: 'habit-title-' + this.widget.habit.id.toString(),
          child: Text(this.widget.habit.title,
              style: Theme.of(context).textTheme.headline6),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                "${timesProgress.toString()}/${timesTarget.toString()} $timesTargetType Completed",
                style: subtitleStyle),
            Text(this.widget.habit.reminder, style: subtitleStyle),
          ],
        ),
        trailing: loading
            ? CircularProgressIndicator()
            : Wrap(
                children: <Widget>[
                  IconButton(
                    icon: habit.timesProgress < habit.timesTarget
                        ? _addIcon
                        : Container(),
                    onPressed: () => habit.timesProgress < habit.timesTarget
                        ? {
                            setState(() {
                              loading = true;
                              habit.timesProgress++;
                            }),
                            widget.habitMaster
                                .updateStatus(
                                  habit: habit,
                                  dateTime: widget.date,
                                )
                                .then(
                                  (sts) => setState(() {
                                    loading = false;
                                  }),
                                ),
                          }
                        : {},
                  ),
                  IconButton(
                    icon: habit.timesProgress > 0 ? _minusIcon : Container(),
                    onPressed: () => habit.timesProgress > 0
                        ? {
                            setState(() {
                              loading = true;
                              habit.timesProgress--;
                            }),
                            widget.habitMaster
                                .updateStatus(
                                  habit: habit,
                                  dateTime: widget.date,
                                )
                                .then(
                                  (sts) => setState(() {
                                    loading = false;
                                  }),
                                )
                          }
                        : {},
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
          arguments: this.widget.habit,
        ),
      ),
    );
  }
}
