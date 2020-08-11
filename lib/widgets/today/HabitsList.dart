import 'package:CleanHabits/data/HabitMasterService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/BooleanListItem.dart';
import 'package:CleanHabits/widgets/basic/TimesListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HabitsList extends StatefulWidget {
  //
  final DateTime date;
  final HabitMasterService habitMaster = new HabitMasterService();
  HabitsList({this.date});

  @override
  _HabitsListState createState() => _HabitsListState();
}

class _HabitsListState extends State<HabitsList> {
  //
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  //
  List<Habit> habits = new List();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    //
    widget.habitMaster.list(widget.date).then(
          (data) => setState(() {
            habits = data;
            loading = false;
          }),
        );
  }

  Widget showLoading() {
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: 1,
      itemBuilder: (context, index, anim) =>
          AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 1000),
        child: FadeInAnimation(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWithData() {
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: habits.length,
      itemBuilder: (context, index, anim) =>
          AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 1000),
        child: FadeInAnimation(
          child: habits[index].isYNType
              ? BooleanListItem(habit: habits[index], date: widget.date)
              : TimesListItem(habit: habits[index], date: widget.date),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      List<int>.generate(habits.length - 1, (i) => i + 1).forEach((id) {
        _listKey.currentState.insertItem(id);
      });
    }
    //
    return loading ? showLoading() : buildWithData();
  }
}
