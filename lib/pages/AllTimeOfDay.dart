import 'package:CleanHabits/data/provider/ProviderFactory.dart';
import 'package:CleanHabits/domain/TimeArea.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class AllTimeOfDay extends StatefulWidget {
  @override
  _AllTimeOfDayState createState() => _AllTimeOfDayState();
}

class _AllTimeOfDayState extends State<AllTimeOfDay> {
  final sp = ProviderFactory.settingsProvider;
  List<TimeArea> data = ProviderFactory.settingsProvider.timeArea;

  var _format = DateFormat("HH:mm");

  @override
  void initState() {
    super.initState();
  }

  int _toMinutes(TimeOfDay _time) {
    return (_time.hour * 60) + _time.minute;
  }

  _sort() {
    data.sort((prev, after) =>
        _toMinutes(prev.startTime) < _toMinutes(after.startTime) ? -1 : 1);
  }

  showTextWTimePicker(int index, BuildContext context) {
    showTimePicker(
      initialTime: data[index].startTime,
      context: context,
    ).then(
      (value) => setState(() {
        data[index].startTime = value == null ? data[index].startTime : value;
      }),
    );
  }

  String _formatTime(TimeOfDay _time) {
    return _format.format(DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      _time.hour,
      _time.minute,
    ));
  }

  TimelineTile _startTile() {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineX: 0.30,
      isFirst: true,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: accentColor,
      ),
      topLineStyle: LineStyle(color: accentColor),
      bottomLineStyle: LineStyle(color: accentColor),
      rightChild: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: ListTile(
          title: Text(
            'Wake Up',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: accentColor,
            ),
          ),
        ),
      ),
    );
  }

  TimelineTile _endTile() {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineX: 0.30,
      isLast: true,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: accentColor,
      ),
      topLineStyle: LineStyle(color: accentColor),
      bottomLineStyle: LineStyle(color: accentColor),
      rightChild: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: ListTile(
          title: Text(
            'Sleep',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: accentColor,
            ),
          ),
        ),
      ),
    );
  }

  TimelineTile _timeArea(index) {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;
    var timeColor = _theme.textTheme.subtitle2.color;

    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineX: 0.30,
      indicatorStyle: IndicatorStyle(
        width: 34,
        color: accentColor,
        iconStyle: IconStyle(
          color: _theme.scaffoldBackgroundColor,
          iconData: data[index].icon,
        ),
      ),
      topLineStyle: LineStyle(color: accentColor),
      bottomLineStyle: LineStyle(color: accentColor),
      leftChild: ListTile(
        title: Row(
          children: [
            Icon(
              Icons.settings,
              color: timeColor,
            ),
            Spacer(),
            Text(
              _formatTime(data[index].startTime),
              style: TextStyle(color: timeColor),
            ),
          ],
        ),
        onTap: () => showTextWTimePicker(index, context),
      ),
      rightChild: Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: ListTile(
          title: Text(
            data[index].area,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var _darkMode = _theme.brightness == Brightness.dark;
    var accentColor = _theme.accentColor;
    _sort();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: accentColor),
        elevation: 0.0,
        title: Text(
          'Time Of Day',
          style: TextStyle(
            color: _darkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: _theme.scaffoldBackgroundColor,
        actions: [
          FlatButton(
              onPressed: () {
                sp.timeArea = data;
                Navigator.pop(context);
              },
              child: Text('Save', style: TextStyle(color: accentColor)))
        ],
      ),
      body: ListView.builder(
        itemCount: data.length + 2,
        itemBuilder: (context, index) => index == 0
            ? _startTile()
            : ((index == data.length + 1) ? _endTile() : _timeArea(index - 1)),
      ),
    );
  }
}
