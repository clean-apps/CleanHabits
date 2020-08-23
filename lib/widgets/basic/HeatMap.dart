import 'dart:math';

import 'package:CleanHabits/widgets/basic/HeatMapCalendar2.dart';
import 'package:flutter/material.dart';

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
      minThreshold == 0 ? 1 : minThreshold: accentColor.withAlpha(0),
      ((avgThreshold - minThreshold) / 2 + minThreshold).toInt():
          accentColor.withAlpha(100),
      avgThreshold: accentColor.withAlpha(130),
      ((maxThreshold - avgThreshold) / 2 + avgThreshold).toInt():
          accentColor.withAlpha(180),
      maxThreshold: accentColor.withAlpha(255),
    };

    return HeatMapCalendar2(
      key: this.key,
      input: data,
      colorThresholds: _colorThresholds,
      squareSize: 24.0,
      textOpacity: 0.3,
      labelTextColor: Colors.blueGrey,
    );
  }
}
