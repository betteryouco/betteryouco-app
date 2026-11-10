import '../screens/premium_user/profile_controller.dart';

class ProfileModel {
  final int age;
  final Gender? gender;

  /// Stored in centimeters
  final double height;

  /// Stored in kilograms
  final double weight;

  final HeightUnit heightUnit;
  final WeightUnit weightUnit;

  final double? averageSleep;
  final DailyActivity? dailyActivity;
  final bool profileComplete;

  final bool pushNotifications;
  final bool emailUpdates;
  final bool sessionReminders;
  final bool assessmentReminders;

  const ProfileModel({
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.heightUnit,
    required this.weightUnit,
    this.averageSleep,
    this.dailyActivity,
    this.profileComplete = false,
    this.pushNotifications = false,
    this.emailUpdates = false,
    this.sessionReminders = false,
    this.assessmentReminders = false,
  });

  ProfileModel copyWith({
    int? age,
    Gender? gender,
    double? height,
    double? weight,
    HeightUnit? heightUnit,
    WeightUnit? weightUnit,
    double? averageSleep,
    DailyActivity? dailyActivity,
    bool? profileComplete,
    bool? pushNotifications,
    bool? emailUpdates,
    bool? sessionReminders,
    bool? assessmentReminders,
  }) {
    return ProfileModel(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      heightUnit: heightUnit ?? this.heightUnit,
      weightUnit: weightUnit ?? this.weightUnit,
      averageSleep: averageSleep ?? this.averageSleep,
      dailyActivity: dailyActivity ?? this.dailyActivity,
      profileComplete: profileComplete ?? this.profileComplete,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailUpdates: emailUpdates ?? this.emailUpdates,
      sessionReminders: sessionReminders ?? this.sessionReminders,
      assessmentReminders: assessmentReminders ?? this.assessmentReminders,
    );
  }

  factory ProfileModel.empty() {
    return const ProfileModel(
      age: 20,
      gender: null,
      height: 175,
      weight: 60,
      heightUnit: HeightUnit.cm,
      weightUnit: WeightUnit.kg,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "age": age,
      "gender": gender?.name,
      "height": height,
      "weight": weight,
      "height_unit": heightUnit.name,
      "weight_unit": weightUnit.name,
    };
  }

  /// The `/client/profile/show` endpoint wraps the payload as
  /// `{"success": true, "data": {...}}` — unwrap it here, the same
  /// convention `AssessmentResponse.fromJson` follows.
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? json;

    return ProfileModel(
      age: data["age"] ?? 20,
      gender: data["gender"] == null
          ? null
          : Gender.values.firstWhere(
            (e) => e.name == data["gender"],
        orElse: () => Gender.preferNotToSay,
      ),
      height: double.tryParse('${data["height"] ?? 175}') ?? 175.0,
      weight: double.tryParse('${data["weight"] ?? 60}') ?? 60.0,
      heightUnit: HeightUnit.values.firstWhere(
            (e) => e.name == (data["height_unit"] ?? "cm"),
        orElse: () => HeightUnit.cm,
      ),
      weightUnit: WeightUnit.values.firstWhere(
            (e) => e.name == (data["weight_unit"] ?? "kg"),
        orElse: () => WeightUnit.kg,
      ),
      averageSleep: data["average_sleep"] == null
          ? null
          : double.tryParse('${data["average_sleep"]}'),
      dailyActivity: data["daily_activity"] == null
          ? null
          : DailyActivity.values.firstWhere(
            (e) => e.name == data["daily_activity"],
        orElse: () => DailyActivity.sedentary,
      ),
      profileComplete: data["profile_complete"] == true,
      pushNotifications: data["push_notifications"] == true,
      emailUpdates: data["email_updates"] == true,
      sessionReminders: data["session_reminders"] == true,
      assessmentReminders: data["assessment_reminders"] == true,
    );
  }
}