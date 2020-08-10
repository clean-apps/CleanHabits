import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  LineChart(this.seriesList, {this.animate});

  factory LineChart.withData(
    String id,
    List<LinearData> data,
    BuildContext context,
  ) {
    return new LineChart(
      _createData(id, data, context),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList,
        animate: animate,
        defaultRenderer: new charts.LineRendererConfig(
          includePoints: true,
          includeArea: true,
          stacked: true,
        ),
        domainAxis: new charts.NumericAxisSpec(
          tickProviderSpec: new charts.BasicNumericTickProviderSpec(
            zeroBound: false,
            dataIsInWholeNumbers: false,
            desiredTickCount: seriesList[0].data.length,
          ),
          tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
            (num value) =>
                (seriesList[0].data[value.toInt() - 1] as LinearData).xLabel,
          ),
        ));
  }

  static List<charts.Series<LinearData, int>> _createData(
    id,
    List<LinearData> data,
    BuildContext context,
  ) {
    var _theme = Theme.of(context);
    var accentColor = _theme.accentColor;
    var accentHex =
        '#${(accentColor.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

    return [
      new charts.Series<LinearData, int>(
        id: id,
        colorFn: (_, __) => charts.Color.fromHex(code: accentHex),
        domainFn: (LinearData data, _) => data.xValue,
        measureFn: (LinearData data, _) => data.yValue,
        data: data,
      )
    ];
  }
}

class LinearData {
  final String xLabel;
  final int xValue;
  final int yValue;

  LinearData(this.xLabel, this.xValue, this.yValue);
}
