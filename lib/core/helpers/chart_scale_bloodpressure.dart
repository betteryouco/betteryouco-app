import '../../models/chart_point_blood_pressure.dart';

class ChartScale {
  final double minY;
  final double maxY;

  ChartScale({required this.minY, required this.maxY});
}

ChartScale calculateBloodPressureScale(List<BloodPressureChartPoint> points) {
  // The Y-axis always starts at 0 — only the top of the range adapts to
  // the data so the chart doesn't feel needlessly squashed.
  if (points.isEmpty) {
    return ChartScale(minY: 0, maxY: 120);
  }

  final systolic = points.map((e) => e.systolic).toList();
  final maxVal = systolic.reduce((a, b) => a > b ? a : b);

  double paddedMax = maxVal + 10;
  if (!paddedMax.isFinite) paddedMax = 120;

  double ceilTo10(double v) => (v / 10).ceil() * 10;

  return ChartScale(minY: 0, maxY: ceilTo10(paddedMax));
}
