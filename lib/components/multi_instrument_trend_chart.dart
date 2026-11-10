import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/instrument_trend_response.dart';
import '../theme/app_colors.dart';

/// DASS-21 / GAD-7 / PHQ-8 plotted as three independent lines on one
/// chart. DASS-21 (0-126, combined per sitting) gets its own Y-axis;
/// GAD-7 and PHQ-8 (0-21 / 0-24 — close enough ranges to read well
/// together) share a second axis, so all three plot at their real score
/// rather than being squashed flat against a 0-126 scale. A DateTimeAxis
/// (not a shared category axis) means each series positions correctly by
/// its own submission dates regardless of what the other two have data
/// for — the actual "handle missing/limited data" requirement: an
/// instrument the user hasn't taken yet just contributes no line, rather
/// than breaking or misaligning the ones that do have data.
class MultiInstrumentTrendChart extends StatelessWidget {
  final InstrumentTrendResponse trend;

  const MultiInstrumentTrendChart({super.key, required this.trend});

  static const _dassColor = AppColors.primaryBtn;
  static const _gad7Color = AppColors.tags8;
  static const _phq8Color = Color(0xFF3B6FB8);

  @override
  Widget build(BuildContext context) {
    final hasAnyData = trend.dass21.hasData || trend.gad7.hasData || trend.phq8.hasData;

    if (!hasAnyData) {
      return Container(
        height: 235,
        alignment: Alignment.center,
        child: Text(
          "No assessments taken yet — your DASS-21, GAD-7 and PHQ-8 scores will chart here once you've taken at least one.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, color: Color(0xFF685355)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 235,
          child: SfCartesianChart(
            margin: EdgeInsets.zero,
            plotAreaBorderWidth: 0,
            enableAxisAnimation: true,
            legend: const Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              canShowMarker: true,
              builder: (data, point, series, pointIndex, seriesIndex) {
                final p = data as InstrumentTrendPoint;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${series.name}: ${p.score}${p.interpretation != null ? ' · ${p.interpretation}' : ''}",
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                );
              },
            ),
            primaryXAxis: DateTimeAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
              axisLine: const AxisLine(width: 0),
              labelStyle: const TextStyle(
                fontSize: 11,
                color: Color(0xff7D7D7D),
                fontWeight: FontWeight.w500,
              ),
              dateFormat: DateFormat('MMM d'),
            ),
            primaryYAxis: NumericAxis(
              name: 'dass',
              minimum: 0,
              maximum: 126,
              interval: 21,
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
              labelStyle: const TextStyle(fontSize: 11, color: Color(0xff8E8E8E)),
              majorGridLines: MajorGridLines(width: 1, color: Colors.grey.shade300),
              title: const AxisTitle(
                text: 'DASS-21',
                textStyle: TextStyle(fontSize: 10, color: _dassColor, fontWeight: FontWeight.w700),
              ),
            ),
            axes: const <ChartAxis>[
              NumericAxis(
                name: 'anxietyDepression',
                minimum: 0,
                maximum: 24,
                interval: 4,
                opposedPosition: true,
                axisLine: AxisLine(width: 0),
                majorTickLines: MajorTickLines(size: 0),
                majorGridLines: MajorGridLines(width: 0),
                labelStyle: TextStyle(fontSize: 11, color: Color(0xff8E8E8E)),
                title: AxisTitle(
                  text: 'GAD-7 / PHQ-8',
                  textStyle: TextStyle(fontSize: 10, color: _gad7Color, fontWeight: FontWeight.w700),
                ),
              ),
            ],
            series: <CartesianSeries>[
              if (trend.dass21.hasData)
                LineSeries<InstrumentTrendPoint, DateTime>(
                  name: 'DASS-21',
                  dataSource: trend.dass21.points,
                  xValueMapper: (point, _) => point.date,
                  yValueMapper: (point, _) => point.score,
                  yAxisName: 'dass',
                  color: _dassColor,
                  width: 2,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    width: 8,
                    height: 8,
                    shape: DataMarkerType.circle,
                    color: _dassColor,
                    borderWidth: 2,
                    borderColor: Colors.white,
                  ),
                ),
              if (trend.gad7.hasData)
                LineSeries<InstrumentTrendPoint, DateTime>(
                  name: 'GAD-7',
                  dataSource: trend.gad7.points,
                  xValueMapper: (point, _) => point.date,
                  yValueMapper: (point, _) => point.score,
                  yAxisName: 'anxietyDepression',
                  color: _gad7Color,
                  width: 2,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    width: 8,
                    height: 8,
                    shape: DataMarkerType.circle,
                    color: _gad7Color,
                    borderWidth: 2,
                    borderColor: Colors.white,
                  ),
                ),
              if (trend.phq8.hasData)
                LineSeries<InstrumentTrendPoint, DateTime>(
                  name: 'PHQ-8',
                  dataSource: trend.phq8.points,
                  xValueMapper: (point, _) => point.date,
                  yValueMapper: (point, _) => point.score,
                  yAxisName: 'anxietyDepression',
                  color: _phq8Color,
                  width: 2,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    width: 8,
                    height: 8,
                    shape: DataMarkerType.circle,
                    color: _phq8Color,
                    borderWidth: 2,
                    borderColor: Colors.white,
                  ),
                ),
            ],
          ),
        ),
        if (!trend.dass21.hasData || !trend.gad7.hasData || !trend.phq8.hasData) ...[
          const SizedBox(height: 8),
          Text(
            "${[
              if (!trend.dass21.hasData) "DASS-21",
              if (!trend.gad7.hasData) "GAD-7",
              if (!trend.phq8.hasData) "PHQ-8",
            ].join(', ')} — not taken in this window yet.",
            style: const TextStyle(fontSize: 11, color: Color(0xff8E8E8E)),
          ),
        ],
      ],
    );
  }
}
