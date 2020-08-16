import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/widgets/hprogress/HabitCompletionRate.dart';
import 'package:CleanHabits/widgets/hprogress/HabitHeatMap.dart';
import 'package:CleanHabits/widgets/hprogress/HabitStatusSummary.dart';
import 'package:CleanHabits/widgets/hprogress/HabitStreaks.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum HabitOptions { edit, delete }

class HabitProgress extends StatefulWidget {
  final HabitMasterService habitMaster = new HabitMasterService();
  @override
  _HabitProgressState createState() => _HabitProgressState();
}

class _HabitProgressState extends State<HabitProgress> {
  final int index = 1;
  var loading = false;

  AppBar _appBar(BuildContext context, Habit habit) {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;

    return new AppBar(
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: accentColor),
      title: Hero(
        tag: 'habit-title-' + habit.id.toString(),
        child: Text(
          habit.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      actions: [
        loading
            ? IconButton(
                icon: CircularProgressIndicator(),
                onPressed: null,
              )
            : PopupMenuButton<HabitOptions>(
                onSelected: (HabitOptions result) {
                  if (result == HabitOptions.delete) {
                    setState(() {
                      loading = true;
                    });
                    widget.habitMaster.deleteHabit(habit.id).then(
                          (value) => Navigator.pushNamed(context, '/'),
                        );
                  } else if (result == HabitOptions.edit) {
                    Navigator.pushNamed(
                      context,
                      '/edit',
                      arguments: habit,
                    );
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<HabitOptions>>[
                  const PopupMenuItem<HabitOptions>(
                    value: HabitOptions.edit,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<HabitOptions>(
                    value: HabitOptions.delete,
                    child: Text('Delete'),
                  ),
                ],
              )
      ],
      backgroundColor: Colors.white,
      elevation: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Habit habit = ModalRoute.of(context).settings.arguments;

    var _widgetList = <Widget>[
      HabitStatusSummary(habit: habit),
      HabitCompletionRate(habit: habit),
      HabitStreaks(habit: habit),
      HabitHeatMap(habit: habit),
    ];

    return new Scaffold(
      appBar: _appBar(context, habit),
      body: Container(
        color: Colors.grey.withOpacity(0.05),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAnimatedList(
              initialItemCount: _widgetList.length,
              itemBuilder: (context, index, anim) =>
                  AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: FadeInAnimation(child: _widgetList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
