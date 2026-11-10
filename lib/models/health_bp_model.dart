class BloodPressureModel {
  final double? systolic;

  final double? diastolic;

  final String unit;

  final String status;

  const BloodPressureModel({
    this.systolic,

    this.diastolic,

    required this.unit,

    required this.status,
  });

  factory BloodPressureModel.fromJson(Map<String, dynamic> json) {
    return BloodPressureModel(
      systolic: json["systolic"] != null
          ? double.parse(json["systolic"].toString())
          : 0.0,

      diastolic: json["diastolic"] != null
          ? double.parse(json["diastolic"].toString())
          : 0.0,

      unit: json["unit"],

      status: json["status"],
    );
  }
}
