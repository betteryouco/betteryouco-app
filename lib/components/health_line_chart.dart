import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide ChartPoint;

import '../models/chart_point_dass.dart';

class HealthLineChart extends StatelessWidget {
  const HealthLineChart({
    super.key,
    required this.data,
    this.minY = 6,
    this.maxY = 48,
    this.interval = 8,
    this.lineColor = const Color(0xff5A7F38),
    this.animationDuration = 1200,
    this.showTooltip = true,
  });

  final List<ChartPoint> data;

  final double minY;
  final double maxY;
  final double interval;

  final Color lineColor;

  final int animationDuration;

  final bool showTooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,

        plotAreaBorderWidth: 0,

        enableAxisAnimation: true,

        tooltipBehavior: TooltipBehavior(
          enable: showTooltip,
          canShowMarker: true,
          header: '',
          format: 'point.x : point.y',
        ),

        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),

          majorTickLines: const MajorTickLines(size: 0),

          axisLine: const AxisLine(width: 0),

          labelStyle: const TextStyle(
            fontSize: 12,
            color: Color(0xff7D7D7D),
            fontWeight: FontWeight.w500,
          ),

          labelPlacement: LabelPlacement.onTicks,
        ),

        primaryYAxis: NumericAxis(
          minimum: minY,

          maximum: maxY,

          interval: interval,

          axisLine: const AxisLine(width: 0),

          majorTickLines: const MajorTickLines(size: 0),

          labelStyle: const TextStyle(
            fontSize: 12,
            color: Color(0xff8E8E8E),
          ),

          majorGridLines: MajorGridLines(
            width: 1,
            color: Colors.grey.shade300,
          ),
        ),

        series: <CartesianSeries>[
          LineSeries<ChartPoint, String>(
            dataSource: data,

            xValueMapper: (point, _) => point.label,

            yValueMapper: (point, _) => point.value,

            animationDuration: animationDuration.toDouble(),

            color: lineColor,

            width: 2,

            markerSettings: MarkerSettings(
              isVisible: true,
              width: 9,
              height: 9,
              shape: DataMarkerType.circle,
              color: lineColor,
              borderWidth: 2,
              borderColor: Colors.white,
            ),

            dataLabelSettings: const DataLabelSettings(
              isVisible: false,
            ),
          ),
        ],
      ),
    );
  }
}