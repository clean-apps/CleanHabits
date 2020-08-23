import 'package:CleanHabits/data/ProgressStatsService.dart';
import 'package:CleanHabits/widgets/basic/HeatMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DailyTracker extends StatefulWidget {
  final ProgressStatsService statsService = ProgressStatsService();
  @override
  _DailyTrackerState createState() => _DailyTrackerState();
}

class _DailyTrackerState extends State<DailyTracker> {
  Map<DateTime, int> data = Map();
  var type = "Show All";
  var loading = true;
  Key hmcKey = ValueKey('progress-all');

  @override
  void initState() {
    super.initState();
    //
    type = "Show All";
    _loadData();
  }

  void _loadData() {
    widget.statsService.getHeatMapData(type).then(
          (value) => setState(() {
            data = value;
            loading = false;
          }),
        );
  }

  // ignore: unused_element
  Widget _typeDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        items: ["Show All", "Completed", "Started", "Skipped"]
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

  onFilter(type) {
    setState(() {
      type = type;
      loading = true;
    });
    _loadData();
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
        trailing: ConstrainedBox(
          constraints: BoxConstraints.expand(width: 24.0, height: 24.0),
          child: loading ? CircularProgressIndicator() : Container(),
        ),
        // _typeDropDown(),
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
                : HeatMap(key: hmcKey, data: this.data),
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
