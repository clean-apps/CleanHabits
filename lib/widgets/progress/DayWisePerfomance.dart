import 'dart:math';

import 'package:CleanHabits/widgets/basic/BarChart.dart';
import 'package:CleanHabits/widgets/basic/HorizontalBarChart.dart';
import 'package:flutter/material.dart';

class DayWisePerfomance extends StatefulWidget {
  @override
  _DayWisePerfomanceState createState() => _DayWisePerfomanceState();
}

class _DayWisePerfomanceState extends State<DayWisePerfomance> {
  List<ChartData> data = List();

  @override
  void initState() {
    super.initState();
    //
    data = _getData();
  }

  List<ChartData> _getData() {
    var rng = new Random();
    return [
      new ChartData('Sun', rng.nextInt(25)),
      new ChartData('Mon', rng.nextInt(25)),
      new ChartData('Tue', rng.nextInt(25)),
      new ChartData('Wed', rng.nextInt(25)),
      new ChartData('Thu', rng.nextInt(25)),
      new ChartData('Fri', rng.nextInt(25)),
      new ChartData('Sat', rng.nextInt(25)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      ListTile(
        title: Text(
          'Day Wise Perfomance',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      ConstrainedBox(
        constraints: BoxConstraints.expand(height: 300.0),
        child: HorizontalBarChart.withData(
            'Day Wise Perfomance', this.data, context),
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
