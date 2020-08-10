import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  BarChart(this.seriesList, {this.animate});

  factory BarChart.withData(
    String id,
    List<ChartData> data,
    BuildContext context,
  ) {
    return new BarChart(_createData(id, data, context), animate: true);
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
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

    return [
      new charts.Series<ChartData, String>(
        id: id,
        colorFn: (_, __) => __ < data.length - 1
            ? charts.Color.fromHex(code: textColorHex)
            : charts.Color.fromHex(code: accentHex),
        domainFn: (ChartData data, _) => data.xValue,
        measureFn: (ChartData data, _) => data.yValue,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class ChartData {
  final String xValue;
  final int yValue;

  ChartData(this.xValue, this.yValue);
}
