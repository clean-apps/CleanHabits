import 'dart:math';

import 'package:CleanHabits/widgets/basic/LineChart.dart';
import 'package:flutter/material.dart';

class CompletionRate extends StatefulWidget {
  @override
  _CompletionRateState createState() => _CompletionRateState();
}

class _CompletionRateState extends State<CompletionRate> {
  //
  List<LinearData> data = List();
  String type = "Weekly";
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

  List<LinearData> _getData() {
    var rng = new Random();
    return [
      new LinearData('W21', 1, rng.nextInt(25)),
      new LinearData('W22', 2, rng.nextInt(25)),
      new LinearData('W23', 3, rng.nextInt(25)),
      new LinearData('W24', 4, rng.nextInt(25)),
      new LinearData('W25', 5, rng.nextInt(25)),
      new LinearData('W26', 6, rng.nextInt(25)),
      new LinearData('W27', 7, rng.nextInt(25)),
      new LinearData('W28', 8, rng.nextInt(25)),
      new LinearData('W29', 9, rng.nextInt(25)),
      new LinearData('W30', 10, rng.nextInt(25)),
    ];
  }

  onFilter(type) {
    debugPrint('completion rate changed to type $type');
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
        value: this.type,
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
        child: LineChart.withData('Weekly Progress', this.data, context),
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
