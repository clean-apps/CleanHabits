import 'package:CleanHabits/data/ProgressStatsService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:flutter/material.dart';

class WeeklyProgress extends StatefulWidget {
  //
  final ProgressStatsService statsService = ProgressStatsService();
  @override
  _WeeklyProgressState createState() => _WeeklyProgressState();
}

class _WeeklyProgressState extends State<WeeklyProgress> {
  List<Habit> weeklyData = List();
  var weeksProgress = 0;
  var weeksTarget = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    //
    _loadData();
  }

  void _loadData() {
    var sum = (int a, int b) => a + b;
    widget.statsService
        .getWeeklyProgressData()
        .then(
          (value) => {
            if (mounted)
              setState(() {
                weeklyData = value;
                weeksProgress =
                    weeklyData.map((e) => e.timesProgress).reduce(sum);
                weeksTarget = weeklyData.map((e) => e.timesTarget).reduce(sum);
                loading = false;
              })
          },
        )
        .whenComplete(() => {
              if (mounted)
                setState(() {
                  loading = false;
                })
            });
  }

  ListTile _weeklyTile(BuildContext context, Habit data) {
    var _theme = Theme.of(context);
    return ListTile(
      leading: CircularProgressIndicator(
        backgroundColor: _theme.textTheme.subtitle2.color.withAlpha(25),
        value: data.timesProgress / data.timesTarget,
      ),
      title: Row(
        children: <Widget>[
          Text(data.title),
          Spacer(),
          Text(data.timesProgress.toString()),
          Text('/'),
          Text(data.timesTarget.toString()),
        ],
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () => Navigator.pushNamed(
        context,
        '/habit/progress',
        arguments: data,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    //
    var widgetList = <Widget>[
      ListTile(
        title: Text('This Week', style: _theme.textTheme.headline6),
        dense: true,
        trailing: loading
            ? ConstrainedBox(
                constraints: BoxConstraints.expand(width: 24.0, height: 24.0),
                child: CircularProgressIndicator(),
              )
            : ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 50),
                child: LinearProgressIndicator(
                  value: weeksTarget == 0 ? 0 : weeksProgress / weeksTarget,
                ),
              ),
      ),
      loading
          ? ConstrainedBox(
              constraints: BoxConstraints.expand(height: 225.0),
              child: Container(),
            )
          : weeklyData.length == 0
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
              : ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const Divider(),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: weeklyData.length,
                  itemBuilder: (context, index) => _weeklyTile(
                    context,
                    weeklyData[index],
                  ),
                )
    ];

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (_, __) => const Divider(),
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
      ),
    );
  }
}
