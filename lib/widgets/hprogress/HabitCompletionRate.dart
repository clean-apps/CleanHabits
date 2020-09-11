import 'package:CleanHabits/data/HabitStatsService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/BarChart.dart';
import 'package:flutter/material.dart';

class HabitCompletionRate extends StatefulWidget {
  final Habit habit;
  final HabitStatsService habitStats = new HabitStatsService();
  HabitCompletionRate({this.habit});

  @override
  _HabitCompletionRateState createState() => _HabitCompletionRateState();
}

class _HabitCompletionRateState extends State<HabitCompletionRate> {
  //
  List<ChartData> data = List();
  bool loading = true;
  //
  String type = "Weekly";
  @override
  void initState() {
    super.initState();
    //
    type = "Weekly";
    _loadData();
  }

  void _loadData() {
    widget.habitStats
        .getCompletionRate(widget.habit, type)
        .then((value) => setState(() {
              data = value;
              loading = false;
            }));
  }

  onFilter(changed) {
    setState(() {
      type = changed;
      loading = true;
    });
    _loadData();
  }

  Widget _typeDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        items: ["Monthly", "Weekly"]
            .map(
              (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
        value: type,
        onChanged: (e) => onFilter(e),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      ListTile(
        title: Text(
          'Completion Rate',
          style: Theme.of(context).textTheme.headline6,
        ),
        trailing: loading
            ? ConstrainedBox(
                constraints: BoxConstraints.expand(width: 24.0, height: 24.0),
                child: CircularProgressIndicator(),
              )
            : _typeDropDown(),
      ),
      ConstrainedBox(
        constraints: BoxConstraints.expand(height: 225.0),
        child: loading
            ? Container()
            : data.length == 0
                ? Center(
                    child: Text(
                    'Not Enough Information',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle2.color,
                    ),
                  ))
                : BarChart.withData('Weekly Progress', data, context),
      )
    ];

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
      ),
    );
  }
}
