import 'dart:math';

import 'package:flutter/material.dart';
import 'package:CleanHabits/widgets/basic/HeatMapCalendar.dart';

class HeatMap extends StatelessWidget {
  final Map<DateTime, int> data;
  final Key key;
  final String range;
  HeatMap({this.key, this.data, this.range = "3 Months"});

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;

    var minThreshold = data.length == 0 ? 0 : data.values.reduce(min);
    var avgThreshold = data.length == 0
        ? 0
        : data.values.reduce((a, b) => a + b) ~/ data.values.length;
    var maxThreshold = data.length == 0 ? 0 : data.values.reduce(max);

    var _colorThresholds = maxThreshold == 0
        ? {
            0: _theme.brightness == Brightness.dark
                ? Colors.white10
                : Colors.black12
          }
        : {
            0: _theme.brightness == Brightness.dark
                ? Colors.white10
                : Colors.black12,
            minThreshold == 0 ? 1 : minThreshold: accentColor.withAlpha(0),
            ((avgThreshold - minThreshold) / 2 + minThreshold).toInt():
                accentColor.withAlpha(100),
            avgThreshold: accentColor.withAlpha(130),
            ((maxThreshold - avgThreshold) / 2 + avgThreshold).toInt():
                accentColor.withAlpha(180),
            maxThreshold: accentColor.withAlpha(255),
          };

    var _darkMode = Theme.of(context).brightness == Brightness.dark;

    var squareSize = this.range == "12 Months"
        ? 4.0
        : (this.range == "6 Months" ? 12.0 : 24.0);

    var weekLabels = this.range == "12 Months"
        ? ['', '', '', '', '', '', '']
        : ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    var monthsLabels = this.range == "12 Months"
        ? [
            "",
            "J",
            "F",
            "M",
            "A",
            "M",
            "J",
            "J",
            "A",
            "S",
            "O",
            "N",
            "D",
          ]
        : [
            "",
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
          ];

    return HeatMapCalendar(
      key: this.key,
      input: data,
      colorThresholds: _colorThresholds,
      squareSize: squareSize,
      textOpacity: 1.0,
      labelTextColor: Colors.blueGrey,
      dayTextColor: Theme.of(context).textTheme.subtitle2.color,
      displayDates: _darkMode ? true : false,
      weekDaysLabels: weekLabels,
      monthsLabels: monthsLabels,
    );
  }
}
