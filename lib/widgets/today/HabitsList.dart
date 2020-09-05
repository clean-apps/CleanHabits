import 'package:flutter/material.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:CleanHabits/widgets/basic/BooleanListItem.dart';
import 'package:CleanHabits/widgets/basic/TimesListItem.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HabitsList extends StatelessWidget {
  //
  final List<Habit> habits;
  final DateTime date;
  final ValueChanged<Habit> onEdit;
  final ValueChanged<Habit> onDelete;
  final ValueChanged<Habit> onSkip;
  HabitsList({this.habits, this.date, this.onEdit, this.onDelete, this.onSkip});

  Widget _emptyList(context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 30,
              ),
              child: Image.asset(
                _darkMode
                    ? 'assets/no-habit-dark.png'
                    : 'assets/no-habit-light.png',
                width: 250,
                height: 250,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Text(
                'No Habits Found',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Text(
              'Motivation is what gets you started',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text(
              'Habit is what gets you going',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: FloatingActionButton.extended(
                onPressed: () => Navigator.popAndPushNamed(context, '/new'),
                label: Text(
                  'Create New Habit',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slidable(child, Habit habit, context) {
    var _theme = Theme.of(context);
    var _accentColor = _theme.accentColor;
    var _darkMode = _theme.brightness == Brightness.dark;

    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.2,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          icon: Icons.edit,
          color: _darkMode ? Colors.black : Colors.white,
          foregroundColor: _accentColor,
          onTap: () => this.onEdit(habit),
        ),
        IconSlideAction(
            caption: 'Delete',
            icon: Icons.delete,
            color: _darkMode ? Colors.black : Colors.white,
            foregroundColor: _accentColor,
            onTap: () => this.onDelete(habit)),
      ],
      child: child,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Skip',
          icon: Icons.skip_next,
          color: _darkMode ? Colors.black : Colors.white,
          foregroundColor: _accentColor,
          onTap: () => this.onSkip(habit),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return habits.length == 0
        ? SliverList(
            delegate: new SliverChildListDelegate(
            [_emptyList(context)],
          ))
        : SliverList(
            delegate: new SliverChildListDelegate(
              habits
                  .asMap()
                  .entries
                  .map(
                    (entry) => AnimationConfiguration.staggeredList(
                      position: entry.key,
                      duration: const Duration(milliseconds: 1000),
                      child: FadeInAnimation(
                        child: _slidable(
                          entry.value.isYNType
                              ? BooleanListItem(
                                  habit: entry.value,
                                  date: this.date,
                                )
                              : TimesListItem(
                                  habit: entry.value,
                                  date: this.date,
                                ),
                          entry.value,
                          context,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
  }
}
