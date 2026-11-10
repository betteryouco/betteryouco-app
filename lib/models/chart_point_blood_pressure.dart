class BloodPressureChartPoint {
  final DateTime time;
  final double systolic;
  final double diastolic;

  BloodPressureChartPoint({
    required this.time,
    required this.systolic,
    required this.diastolic,
  });
  factory BloodPressureChartPoint.fromJson(
      Map<String, dynamic> json,
      ) {
    return BloodPressureChartPoint(
      time: DateTime.parse(json["recorded_at"]),
      systolic: double.tryParse(json["systolic"]?.toString() ?? '') ?? 0.0,
      diastolic: double.tryParse(json["diastolic"]?.toString() ?? '') ?? 0.0,
    );
  }

}