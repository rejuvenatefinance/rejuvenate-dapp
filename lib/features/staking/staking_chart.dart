import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../providers/wallet_connection_provider.dart';
import '../../utils/extensions.dart';

class StakingChart extends ConsumerWidget {
  const StakingChart({Key? key}) : super(key: key);

  charts.LineRendererConfig<num>? _lineRendererConfig() {
    return charts.LineRendererConfig(
      includeArea: true,
      stacked: true,
      areaOpacity: 0.6,
    );
  }

  charts.NumericAxisSpec _axisSpec(BuildContext context) {
    final labelStyle = charts.TextStyleSpec(
      color: context.theme().onBackground.toChartColor(),
    );

    final lineStyle = charts.LineStyleSpec(
      color: context.theme().background.withOpacity(0.5).toChartColor(),
      dashPattern: const [4, 4],
    );

    return charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        labelAnchor: charts.TickLabelAnchor.before,
        labelJustification: charts.TickLabelJustification.outside,
        labelStyle: labelStyle,
        lineStyle: lineStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: min(
          400.0,
          context.height() * 0.4,
        ),
      ),
      child: Card(
        elevation: 10.0,
        child: Container(
          padding: const EdgeInsets.all(
            16.0,
          ),
          color: context.theme().background.lighten(
                0.1,
              ),
          child: charts.LineChart(
            _queryData(context, ref),
            defaultRenderer: _lineRendererConfig(),
            primaryMeasureAxis: _axisSpec(context),
            domainAxis: _axisSpec(context),
            behaviors: [
              charts.ChartTitle(
                "Staked Rejuvenate",
                behaviorPosition: charts.BehaviorPosition.top,
                titleOutsideJustification: charts.OutsideJustification.start,
                innerPadding: 24,
                titleStyleSpec: charts.TextStyleSpec(
                  color: context.theme().onBackground.toChartColor(),
                ),
              ),
              charts.SeriesLegend(
                position: charts.BehaviorPosition.end,
              ),
            ],
            animate: true,
          ),
        ),
      ),
    );
  }

  List<charts.Series<Point<int>, int>> _queryData(
    BuildContext context,
    WidgetRef ref,
  ) {
    final walletConnect = ref.watch(walletConnectionProvider);
    if (!walletConnect.isConnected) {
      return [];
    }

    final colorOne = context.theme().primaryContainer.toChartColor();
    final colorTwo = context.theme().primary.darken(0.2).toChartColor();
    final colorThree = context.theme().primary.toChartColor();

    var dataOne = const [
      Point(0, 5),
      Point(1, 25),
      Point(2, 100),
      Point(3, 75),
    ];

    var dataTwo = const [
      Point(0, 10),
      Point(1, 50),
      Point(2, 200),
      Point(3, 150),
    ];

    var dataThree = const [
      Point(0, 15),
      Point(1, 75),
      Point(2, 300),
      Point(3, 225),
    ];

    return [
      charts.Series<Point<int>, int>(
        id: 'FLEX',
        colorFn: (_, __) => colorOne,
        domainFn: (Point<int> data, _) => data.x,
        measureFn: (Point<int> data, _) => data.y,
        data: dataOne,
      ),
      charts.Series<Point<int>, int>(
        id: '30D',
        colorFn: (_, __) => colorTwo,
        domainFn: (Point<int> data, _) => data.x,
        measureFn: (Point<int> data, _) => data.y,
        data: dataTwo,
      ),
      charts.Series<Point<int>, int>(
        id: '90D',
        colorFn: (_, __) => colorThree,
        domainFn: (Point<int> data, _) => data.x,
        measureFn: (Point<int> data, _) => data.y,
        data: dataThree,
      ),
    ];
  }
}
