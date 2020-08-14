import 'package:CleanHabits/data/ProgressStatsService.dart';
import 'package:CleanHabits/widgets/basic/HeatMap.dart';
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

  onFilter(type) {
    setState(() {
      type = type;
      loading = true;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      data: data,
      type: type,
      loading: loading,
      onFilter: (type) => onFilter(type),
    );
  }
}
