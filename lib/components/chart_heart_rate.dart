import 'package:betteryou_co/models/chart_point_blood_pressure.dart';
import 'package:betteryou_co/models/chart_point_heart_rate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide ChartPoint;

import '../models/chart_point_dass.dart';

class ChartHeartRate extends StatelessWidget {
  const ChartHeartRate({
    super.key,
    required this.data,
    this.minY = 0,
    this.maxY = 140,
    this.interval = 10,
    this.baseline = 70,
    this.lineColor = const Color(0xff5A7F38),
    this.animationDuration = 1200,
    this.showTooltip = true,
  });

  final List<HeartRateChartPoint> data;

  final double minY;
  final double maxY;
  final double interval;
  final double baseline;

  final Color lineColor;

  final int animationDuration;

  final bool showTooltip;

  @override
  Widget build(BuildContext context) {

    final times = data.map((e) => e.time).toList()..sort();

    final DateTime minTime = times.first;
    final DateTime maxTime = times.last;

// Add padding so axis is never zero-length
    final DateTime paddedMin = minTime.subtract(const Duration(hours: 1));
    final DateTime paddedMax = maxTime.add(const Duration(hours: 1));

    return SizedBox(
      height: 200,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,

        enableAxisAnimation: true,
        primaryXAxis: DateTimeAxis(
          minimum: paddedMin,
          maximum: paddedMax,
          intervalType: DateTimeIntervalType.hours,
          dateFormat: DateFormat('dd-MMM\nhh:mm a'),
          majorGridLines: const MajorGridLines(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: const AxisLine(width: 0),
          labelStyle: const TextStyle(
            fontSize: 11,
            color: Color(0xff7D7D7D),
            fontWeight: FontWeight.w500,
          ),
        ),
        primaryYAxis: NumericAxis(
          minimum: (minY / 10).floor() * 10,

          maximum: (maxY / 10).ceil() * 10,

          interval: interval,

          axisLine: const AxisLine(width: 0),

          majorTickLines: const MajorTickLines(size: 0),

          labelStyle: const TextStyle(fontSize: 12, color: Color(0xff8E8E8E)),

          majorGridLines: MajorGridLines(width: 1, color: Colors.grey.shade300),
        ),
        series: <CartesianSeries>[
          // Baseline
          LineSeries<HeartRateChartPoint, DateTime>(
            dataSource: data,
            xValueMapper: (point, _) => point.time,
            yValueMapper: (_, __) => baseline,
            color: Colors.green,
            width: 2,
            dashArray: const <double>[8, 4],
            animationDuration: animationDuration.toDouble(),
            markerSettings: const MarkerSettings(isVisible: false),
          ),

          // SYS
          LineSeries<HeartRateChartPoint, DateTime>(
            dataSource: data,
            xValueMapper: (point, _) => point.time,
            yValueMapper: (point, _) => point.value,
            color: Colors.red,
            width: 3,
            animationDuration: animationDuration.toDouble(),
            markerSettings: const MarkerSettings(
              isVisible: true,
              color: Colors.red,
              borderColor: Colors.white,
              borderWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}
