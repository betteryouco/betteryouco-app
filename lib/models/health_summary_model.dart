import 'chart_point_blood_pressure.dart';
import 'chart_point_heart_rate.dart';
import 'chart_point_sleep.dart';
import 'health_bmi_model.dart';
import 'health_bp_model.dart';
import 'health_hr_model.dart';
import 'health_sleep_model.dart';

class HealthSummaryModel {
  final String date;
  final BMIModel bmi;
  final HeartRateModel heartRate;
  final BloodPressureModel bloodPressure;
  final SleepModel? sleep;

  final List<BloodPressureChartPoint> bloodPressureChart;
  final List<HeartRateChartPoint> heartRateChart;
  final List<SleepChartPoint> sleepChart;

  const HealthSummaryModel({
    required this.date,
    required this.bmi,
    required this.heartRate,
    required this.bloodPressure,
    this.sleep,
    required this.bloodPressureChart,
    required this.heartRateChart,
    this.sleepChart = const [],
  });

  factory HealthSummaryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return HealthSummaryModel(
      date: json['date'],
      bmi: BMIModel.fromJson(data['bmi']),
      heartRate: HeartRateModel.fromJson(data['heart_rate']),
      bloodPressure: BloodPressureModel.fromJson(
        data['blood_pressure'],
      ),
      sleep: data['sleep'] != null
          ? SleepModel.fromJson(data['sleep'])
          : null,
      bloodPressureChart:
      (data["blood_pressure_chart"] as List)
          .map(
            (e) => BloodPressureChartPoint.fromJson(e),
      )
          .toList(),

      heartRateChart:
      (data["heart_rate_chart"] as List)
          .map(
            (e) => HeartRateChartPoint.fromJson(e),
      )
          .toList(),

      sleepChart:
      (data["sleep_chart"] as List? ?? [])
          .map(
            (e) => SleepChartPoint.fromJson(e),
      )
          .toList(),
    );
  }
}