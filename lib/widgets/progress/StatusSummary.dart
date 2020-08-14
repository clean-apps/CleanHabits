import 'package:CleanHabits/data/ProgressStatsService.dart';
import 'package:CleanHabits/widgets/basic/BasicTile.dart';
import 'package:flutter/material.dart';

class StatusSummary extends StatefulWidget {
  final ProgressStatsService statsService = ProgressStatsService();
  @override
  _StatusSummaryState createState() => _StatusSummaryState();
}

class _StatusSummaryState extends State<StatusSummary> {
  var data = StatusSummaryData(todayProgress: 0, todayTarget: 0);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    widget.statsService.getStatusSummaryData().then(
          (value) => setState(() {
            data = value;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        BasicTile(
          title:
              '${data.todayProgress.toString()}/${data.todayTarget.toString()}',
          subtitle1: 'Today\'s Habits',
          subtitle2: 'cool today description',
        )
      ],
    );
  }
}

class StatusSummaryData {
  int todayProgress = 0;
  int todayTarget = 0;
  StatusSummaryData({this.todayProgress, this.todayTarget});
}
