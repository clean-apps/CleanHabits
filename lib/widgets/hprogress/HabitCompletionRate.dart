import 'dart:math';

import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/BarChart.dart';
import 'package:flutter/material.dart';

class HabitCompletionRate extends StatefulWidget {
  final Habit habit;
  HabitCompletionRate({this.habit});

  @override
  _HabitCompletionRateState createState() => _HabitCompletionRateState();
}

class _HabitCompletionRateState extends State<HabitCompletionRate> {
  //
  List<ChartData> data = List();
  String type = "Weekly";
  //
  double completedThisWeek = 0;
  double completedAllTime = 0;

  @override
  void initState() {
    super.initState();
    //
    data = _getData();
    type = "Weekly";

    completedThisWeek = 0.5;
    completedAllTime = 0.85;
  }

  onFilter(changed) {
    debugPrint('filter changed for habit completion rate');
  }

  List<ChartData> _getData() {
    var rng = new Random();
    return [
      new ChartData('W21', rng.nextInt(25)),
      new ChartData('W22', rng.nextInt(25)),
      new ChartData('W23', rng.nextInt(25)),
      new ChartData('W24', rng.nextInt(25)),
      new ChartData('W25', rng.nextInt(25)),
      new ChartData('W26', rng.nextInt(25)),
      new ChartData('W27', rng.nextInt(25)),
      new ChartData('W28', rng.nextInt(25)),
      new ChartData('W29', rng.nextInt(25)),
      new ChartData('W30', rng.nextInt(25)),
    ];
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
        trailing: _typeDropDown(),
      ),
      ConstrainedBox(
        constraints: BoxConstraints.expand(height: 225.0),
        child: BarChart.withData('Weekly Progress', data, context),
      )
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
