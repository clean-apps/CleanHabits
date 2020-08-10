import 'package:CleanHabits/widgets/new/SelectRepeat.dart';
import 'package:flutter/material.dart';

class TabRepeatType extends StatefulWidget {
  final Repeats value;
  final ValueChanged<Repeats> onChange;
  TabRepeatType({this.value, this.onChange});
  @override
  _TabRepeatTypeState createState() => _TabRepeatTypeState();
}

class _TabRepeatTypeState extends State<TabRepeatType> {
  Repeats selected;

  @override
  void initState() {
    super.initState();
    selected = widget.value;
  }

  ListTile _tile({String title, bool value, ValueChanged<bool> onChange}) {
    return ListTile(
      dense: true,
      title: Text(title),
      trailing: IconButton(
        icon: Icon(value ? Icons.check_box : Icons.check_box_outline_blank),
        onPressed: () => onChange(!value),
      ),
    );
  }

  List<Widget> _intervalList() {
    return [1, 2, 3, 4, 5, 6, 7]
        .map(
          (d) => _tile(
            title: 'Every $d Days',
            value: selected.interval == d,
            onChange: (val) => {
              setState(() {
                selected.none = false;
                if (val) selected.interval = d;
              }),
              widget.onChange(selected),
            },
          ),
        )
        .toList();
  }

  List<Widget> _weekdayList() {
    return [
      _tile(
        title: 'Sunday',
        value: selected.hasSun,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasSun = val;
          }),
          widget.onChange(selected),
        },
      ),
      _tile(
        title: 'Monday',
        value: selected.hasMon,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasMon = val;
          }),
          widget.onChange(selected),
        },
      ),
      _tile(
        title: 'Tuesday',
        value: selected.hasTue,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasTue = val;
          }),
          widget.onChange(selected),
        },
      ),
      _tile(
        title: 'Wednesday',
        value: selected.hasWed,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasWed = val;
          }),
          widget.onChange(selected),
        },
      ),
      _tile(
        title: 'Thursday',
        value: selected.hasThu,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasThu = val;
          }),
          widget.onChange(selected),
        },
      ),
      _tile(
        title: 'Friday',
        value: selected.hasFri,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasFri = val;
          }),
          widget.onChange(selected),
        },
      ),
      _tile(
        title: 'Saturday',
        value: selected.hasSat,
        onChange: (val) => {
          setState(() {
            selected.none = false;
            selected.hasSat = val;
          }),
          widget.onChange(selected),
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: selected.isWeekly ? 0 : 1,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Select Repetitions'),
          bottom: TabBar(
            tabs: [
              Tab(child: Text('Weekly')),
              Tab(child: Text('In-Interval')),
            ],
            onTap: (index) => {
              setState(() {
                if (index == 0)
                  selected.isWeekly = true;
                else
                  selected.isWeekly = false;
              }),
              widget.onChange(selected),
            },
          ),
        ),
        body: TabBarView(
          children: [
            ListView(shrinkWrap: true, children: _weekdayList()),
            ListView(shrinkWrap: true, children: _intervalList()),
          ],
        ),
      ),
    );
  }
}
