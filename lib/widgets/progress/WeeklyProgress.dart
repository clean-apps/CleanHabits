import 'package:CleanHabits/domain/Habit.dart';
import 'package:flutter/material.dart';

class WeeklyProgress extends StatefulWidget {
  @override
  _WeeklyProgressState createState() => _WeeklyProgressState();
}

class _WeeklyProgressState extends State<WeeklyProgress> {
  List<Habit> weeklyData = List();

  @override
  void initState() {
    super.initState();
    //
    weeklyData = _getData();
  }

  List<Habit> _getData() {
    var weeklyData = new List<Habit>();
    weeklyData.add(Habit.newTimesHabit(
      id: 1,
      title: "Morning Job",
      completed: 14,
      target: 20,
    ));
    weeklyData.add(Habit.newTimesHabit(
      id: 2,
      title: "Eat Healthy",
      completed: 14,
      target: 20,
    ));
    weeklyData.add(Habit.newTimesHabit(
      id: 3,
      title: "Get Up Early",
      completed: 14,
      target: 20,
    ));
    // weeklyData.add(Habit.newTimesHabit(
    //   id: 4,
    //   title: "Read 20 Pages",
    //   completed: 14,
    //   target: 20,
    // ));
    // weeklyData.add(Habit.newTimesHabit(
    //   id: 5,
    //   title: "Learn A New Word",
    //   completed: 14,
    //   target: 20,
    // ));

    return weeklyData;
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
    var sum = (int a, int b) => a + b;
    var weeksProgress = weeklyData.map((e) => e.timesProgress).reduce(sum);
    var weeksTarget = weeklyData.map((e) => e.timesTarget).reduce(sum);
    //
    var widgetList = <Widget>[
      ListTile(
        title: Text('This Week', style: _theme.textTheme.headline6),
        dense: true,
        trailing: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 50),
          child: LinearProgressIndicator(value: weeksProgress / weeksTarget),
        ),
      ),
      ListView.separated(
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
