import 'package:CleanHabits/data/HabitStatsService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/StackedBarChart.dart';
import 'package:flutter/material.dart';

class HabitStreaks extends StatefulWidget {
  final Habit habit;
  final HabitStatsService habitStats = new HabitStatsService();
  HabitStreaks({this.habit});

  @override
  _HabitStreaksState createState() => _HabitStreaksState();
}

class _HabitStreaksState extends State<HabitStreaks> {
  List<StackData> data = List();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    widget.habitStats.getStreaks(widget.habit).then(
          (value) => setState(() {
            data = value;
            loading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      ListTile(
        title: Text(
          'Best Streaks',
          style: Theme.of(context).textTheme.headline6,
        ),
        trailing: ConstrainedBox(
          constraints: BoxConstraints.expand(width: 24.0, height: 24.0),
          child: loading ? CircularProgressIndicator() : Container(),
        ),
      ),
      loading
          ? ConstrainedBox(
              constraints: BoxConstraints.expand(height: 225.0),
              child: Container(),
            )
          : data.length == 0
              ? ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 225.0),
                  child: Center(
                    child: Text(
                      'Not Enough Information',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle2.color,
                      ),
                    ),
                  ),
                )
              : StackedBarChart(data: data)
    ];

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
      ),
    );
  }
}
