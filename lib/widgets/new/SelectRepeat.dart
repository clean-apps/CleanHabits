import 'package:CleanHabits/widgets/basic/BaseSelection2LineTile.dart';
import 'package:CleanHabits/widgets/new/TabRepeatType.dart';
import 'package:flutter/material.dart';

class SelectRepeat extends StatefulWidget {
  final Repeats value;
  final ValueChanged<Repeats> onChange;
  SelectRepeat({this.value, this.onChange});

  @override
  _SelectRepeatState createState() => _SelectRepeatState();
}

class _SelectRepeatState extends State<SelectRepeat> {
  Repeats selected;

  @override
  void initState() {
    super.initState();
    selected = widget.value == null ? Repeats() : widget.value;
  }

  void _showDialog(context) {
    showDialog(
      context: context,
      builder: (ctxt) => TabRepeatType(
        value: selected,
        onChange: (rep) => setState(() {
          selected = rep;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseSelection2LineTile(
      value: selected.none ? null : selected.displayString(),
      icon: Icon(Icons.repeat),
      title: 'Repeat',
      emptyText: 'Everyday',
      onTap: () => _showDialog(context),
      onClear: () => {
        setState(() {
          selected = Repeats();
        }),
        widget.onChange(selected),
      },
    );
  }
}

class Repeats {
  bool none;
  bool isWeekly;
  bool hasSun;
  bool hasMon;
  bool hasTue;
  bool hasWed;
  bool hasThu;
  bool hasFri;
  bool hasSat;
  int interval;
  Repeats({
    this.none = true,
    this.isWeekly = false,
    this.hasSun = false,
    this.hasMon = false,
    this.hasTue = false,
    this.hasWed = false,
    this.hasThu = false,
    this.hasFri = false,
    this.hasSat = false,
    this.interval = 1,
  });

  String _weeklyString() {
    List days = List();
    if (this.hasSun) days.add("Sun");
    if (this.hasMon) days.add("Mon");
    if (this.hasTue) days.add("Tue");
    if (this.hasWed) days.add("Wed");
    if (this.hasThu) days.add("Thu");
    if (this.hasFri) days.add("Fri");
    if (this.hasSat) days.add("Sat");

    return days.join(',');
  }

  String displayString() {
    return this.isWeekly
        ? 'Weekly ' + _weeklyString()
        : 'In Intervals, every $interval days';
  }
}
