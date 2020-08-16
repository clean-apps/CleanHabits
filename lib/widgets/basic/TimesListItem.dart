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

  IconButton _addIcon(_theme) {
    var _icon = Icon(
      Icons.add_circle_outline,
      size: 40,
      color: _theme.primaryColor.withAlpha(200),
    );

    return IconButton(
      icon: habit.timesProgress < habit.timesTarget ? _icon : Container(),
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
    );
  }

  IconButton _minusIcon(_theme) {
    var _icon = Icon(
      Icons.remove_circle_outline,
      size: 40,
      color: _theme.primaryColor.withAlpha(200),
    );

    return IconButton(
      icon: habit.timesProgress > 0 ? _icon : Container(),
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
    );
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

    var _border = BoxDecoration(
      border: Border.all(color: borderColor),
      color: backgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(7)),
    );

    var _progressTxt =
        "${timesProgress.toString()} / ${timesTarget.toString()} $timesTargetType Completed";

    return Container(
      margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      decoration: _border,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          '/habit/progress',
          arguments: this.widget.habit,
        ),
        child: Card(
          elevation: 0.0,
          color: backgroundColor.withOpacity(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'habit-title-' + this.widget.habit.id.toString(),
                        child: Text(this.widget.habit.title,
                            style: Theme.of(context).textTheme.headline6),
                      ),
                      this.widget.habit.reminder == null
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
                                Text(this.widget.habit.reminder,
                                    style: subtitleStyle)
                              ],
                            ),
                    ],
                  ),
                  Spacer(),
                  loading
                      ? IconButton(
                          icon: CircularProgressIndicator(),
                          onPressed: () => {},
                        )
                      : Container(),
                  loading ? Container() : _minusIcon(_theme),
                  loading ? Container() : _addIcon(_theme),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(_progressTxt, style: subtitleStyle),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                height: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: timesProgress / timesTarget,
                  ),
                ),
              ),
              // ButtonBar(
              //   children: loading
              //       ? [
              //           Padding(
              //             child: Text('.. updating ..'),
              //             padding: EdgeInsets.all(16.0),
              //           )
              //         ]
              //       : [_addIcon(_theme), _minusIcon(_theme)],
              //   buttonPadding: EdgeInsets.zero,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
