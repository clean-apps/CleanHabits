import 'package:CleanHabits/data/ProgressStatsService.dart';
import 'package:CleanHabits/widgets/basic/BarChart.dart';
import 'package:CleanHabits/widgets/basic/HorizontalBarChart.dart';
import 'package:flutter/material.dart';

class DayWisePerfomance extends StatefulWidget {
  final ProgressStatsService statsService = ProgressStatsService();
  @override
  _DayWisePerfomanceState createState() => _DayWisePerfomanceState();
}

class _DayWisePerfomanceState extends State<DayWisePerfomance> {
  List<ChartData> data = List();
  var loading = true;
  var type = "3 Months";

  @override
  void initState() {
    super.initState();
    type = "3 Months";
    _loadData();
  }

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

  void _loadData() {
    widget.statsService.getDayWiseProgressData(type).then(
          (value) => setState(() {
            data = value;
            loading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      ListTile(
        title: Text(
          'Day Wise Perfomance',
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
        constraints: BoxConstraints.expand(height: 300.0),
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
                : HorizontalBarChart.withData(
                    'Day Wise Perfomance',
                    this.data,
                    context,
                  ),
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
