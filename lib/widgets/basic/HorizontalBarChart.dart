import 'package:CleanHabits/widgets/basic/BarChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  HorizontalBarChart(this.seriesList, {this.animate});

  factory HorizontalBarChart.withData(
    String id,
    List<ChartData> data,
    BuildContext context,
  ) {
    return new HorizontalBarChart(
      _createData(id, data, context),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      defaultRenderer: new charts.BarRendererConfig(
        cornerStrategy: const charts.ConstCornerStrategy(12),
      ),
    );
  }

  static List<charts.Series<ChartData, String>> _createData(
    id,
    List<ChartData> data,
    BuildContext context,
  ) {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;
    var accentHex =
        '#${(accentColor.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
    var textColor = _theme.textTheme.subtitle1.color;
    var textColorHex =
        '#${(textColor.value & 0xFFFFFF).toRadixString(16).padLeft(6, 'B').toUpperCase()}';

    var currentDay = DateFormat('EEE').format(DateTime.now());

    return [
      new charts.Series<ChartData, String>(
        id: id,
        fillColorFn: (_, __) => data[__].xValue == currentDay
            ? charts.Color.fromHex(code: accentHex)
            : charts.Color.fromHex(code: textColorHex),
        domainFn: (ChartData data, _) => data.xValue,
        measureFn: (ChartData data, _) => data.yValue,
        data: data,
      )
    ];
  }
}
