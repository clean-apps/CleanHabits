import 'package:CleanHabits/widgets/basic/BasicTile.dart';
import 'package:flutter/material.dart';

class StatusSummary extends StatefulWidget {
  @override
  _StatusSummaryState createState() => _StatusSummaryState();
}

class _StatusSummaryState extends State<StatusSummary> {
  var todayProgress = 2;
  var todayTarget = 7;

  @override
  void initState() {
    super.initState();
    //
    todayProgress = 2;
    todayTarget = 7;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        BasicTile(
          title: '${todayProgress.toString()}/${todayTarget.toString()}',
          subtitle1: 'Today\'s Habits',
          subtitle2: 'cool today description',
        )
      ],
    );
  }
}
