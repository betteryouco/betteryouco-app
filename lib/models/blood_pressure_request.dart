class BloodPressureRequest {
  final DateTime recordedAt;
  final int systolic;
  final int diastolic;
  final String source;

  const BloodPressureRequest({
    required this.recordedAt,
    required this.systolic,
    required this.diastolic,
    this.source = 'manual',
  });

  Map<String, dynamic> toJson() {
    return {
      'recorded_at': recordedAt.toIso8601String(),
      'sys': systolic,
      'dia': diastolic,
      'source': source,
    };
  }
}