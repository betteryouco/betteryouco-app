import 'package:betteryou_co/models/chart_point_blood_pressure.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide ChartPoint;

import '../models/chart_point_dass.dart';

class ChartBloodPressure extends StatelessWidget {
  const ChartBloodPressure({
    super.key,
    required this.data,
    this.minY = 0,
    this.maxY = 180,
    this.interval = 10,
    this.baseline = 120,
    this.lineColor = const Color(0xff5A7F38),
    this.animationDuration = 1200,
    this.showTooltip = true,
  });

  final List<BloodPressureChartPoint> data;

  final double minY;
  final double maxY;
  final double interval;
  final double baseline;

  final Color lineColor;

  final int animationDuration;

  final bool showTooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,

        enableAxisAnimation: true,
        primaryXAxis: DateTimeAxis(
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
          LineSeries<BloodPressureChartPoint, DateTime>(
            dataSource: data,
            xValueMapper: (point, _) => point.time,
            yValueMapper: (_, __) => baseline,
            color: Colors.green,
            width: 2,
            dashArray: const <double>[8, 4],
            animationDuration: animationDuration.toDouble(),
            markerSettings: const MarkerSettings(isVisible: false),
          ),
          // Baseline
          LineSeries<BloodPressureChartPoint, DateTime>(
            dataSource: data,
            xValueMapper: (point, _) => point.time,
            yValueMapper: (_, __) => 80,
            color: Colors.orange.shade200,
            width: 2,
            dashArray: const <double>[10, 6],
            animationDuration: animationDuration.toDouble(),
            markerSettings: const MarkerSettings(isVisible: false),
          ),

          // SYS
          LineSeries<BloodPressureChartPoint, DateTime>(
            dataSource: data,
            xValueMapper: (point, _) => point.time,
            yValueMapper: (point, _) => point.systolic,
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

          // DIA
          LineSeries<BloodPressureChartPoint, DateTime>(
            dataSource: data,
            xValueMapper: (point, _) => point.time,
            yValueMapper: (point, _) => point.diastolic,
            color: Colors.blue,
            width: 3,
            animationDuration: animationDuration.toDouble(),
            markerSettings: const MarkerSettings(
              isVisible: true,
              color: Colors.blue,
              borderColor: Colors.white,
              borderWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}
