import 'dart:math';

import 'package:flutter/material.dart';
import 'package:CleanHabits/widgets/basic/HeatMapCalendar.dart';

class HeatMap extends StatelessWidget {
  final Map<DateTime, int> data;
  final Key key;
  HeatMap({this.key, this.data});

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;

    var minThreshold = data.length == 0 ? 0 : data.values.reduce(min);
    var avgThreshold = data.length == 0
        ? 0
        : data.values.reduce((a, b) => a + b) ~/ data.values.length;
    var maxThreshold = data.length == 0 ? 0 : data.values.reduce(max);

    var _colorThresholds = {
      0: _theme.brightness == Brightness.dark ? Colors.white10 : Colors.black12,
      minThreshold == 0 ? 1 : minThreshold: accentColor.withAlpha(0),
      ((avgThreshold - minThreshold) / 2 + minThreshold).toInt():
          accentColor.withAlpha(100),
      avgThreshold: accentColor.withAlpha(130),
      ((maxThreshold - avgThreshold) / 2 + avgThreshold).toInt():
          accentColor.withAlpha(180),
      maxThreshold: accentColor.withAlpha(255),
    };

    var _darkMode = Theme.of(context).brightness == Brightness.dark;

    return HeatMapCalendar(
      key: this.key,
      input: data,
      colorThresholds: _colorThresholds,
      squareSize: 24.0,
      textOpacity: 1.0,
      labelTextColor: Colors.blueGrey,
      dayTextColor: Theme.of(context).textTheme.subtitle2.color,
      displayDates: _darkMode ? true : false,
    );
  }
}
