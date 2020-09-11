import 'package:CleanHabits/data/HabitStatsService.dart';
import 'package:CleanHabits/domain/Habit.dart';
import 'package:CleanHabits/widgets/basic/HeatMap.dart';
import 'package:flutter/material.dart';

class HabitHeatMap extends StatefulWidget {
  final Habit habit;
  final HabitStatsService habitStats = new HabitStatsService();
  HabitHeatMap({this.habit});

  @override
  _HabitHeatMapState createState() => _HabitHeatMapState();
}

class _HabitHeatMapState extends State<HabitHeatMap> {
  Map<DateTime, int> data = Map();
  bool loading = true;
  Key hmcKey = ValueKey('0');
  //
  var type = "3 Months";

  @override
  void initState() {
    super.initState();
    type = "3 Months";
    this.hmcKey = ValueKey(widget.habit.id);
    _loadData();
  }

  void _loadData() {
    widget.habitStats.getHeatMapData(widget.habit, type).then(
          (value) => setState(() {
            this.data = value;
            this.loading = false;
          }),
        );
  }

  // ignore: unused_element
  Widget _typeDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        items: ["3 Months", "6 Months", "12 Months"]
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        value: this.type,
        onChanged: (e) => {
          setState(() {
            this.type = e;
            this.loading = true;
          }),
          _loadData(),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      ListTile(
        dense: true,
        title: Text(
          'Daily Tracker',
          style: Theme.of(context).textTheme.headline6,
        ),
        trailing: loading
            ? ConstrainedBox(
                constraints: BoxConstraints.expand(width: 24.0, height: 24.0),
                child: CircularProgressIndicator())
            : _typeDropDown(),
      ),
      Padding(
        padding: EdgeInsets.all(10),
        child: loading
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
                : HeatMap(key: hmcKey, data: this.data, range: this.type),
      )
    ];

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
      ),
    );
  }
}
