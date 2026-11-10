class CompleteProfileRequest {
  final int? age;
  final String? gender;

  final double? height;
  final String? heightUnit;

  final double? weight;
  final String? weightUnit;

  final double? averageSleep;
  final String? dailyActivity;

  final bool? pushNotifications;
  final bool? emailUpdates;
  final bool? sessionReminders;
  final bool? assessmentReminders;

  const CompleteProfileRequest({
    this.age,
    this.gender,
    this.height,
    this.heightUnit,
    this.weight,
    this.weightUnit,
    this.averageSleep,
    this.dailyActivity,
    this.pushNotifications,
    this.emailUpdates,
    this.sessionReminders,
    this.assessmentReminders,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (age != null) {
      json['age'] = age;
    }

    if (gender != null) {
      json['gender'] = gender;
    }

    if (height != null) {
      json['height'] = height;
    }

    if (heightUnit != null) {
      json['height_unit'] = heightUnit;
    }

    if (weight != null) {
      json['weight'] = weight;
    }

    if (weightUnit != null) {
      json['weight_unit'] = weightUnit;
    }

    if (averageSleep != null) {
      json['average_sleep'] = averageSleep;
    }

    if (dailyActivity != null) {
      json['daily_activity'] = dailyActivity;
    }

    if (pushNotifications != null) {
      json['push_notifications'] = pushNotifications;
    }

    if (emailUpdates != null) {
      json['email_updates'] = emailUpdates;
    }

    if (sessionReminders != null) {
      json['session_reminders'] = sessionReminders;
    }

    if (assessmentReminders != null) {
      json['assessment_reminders'] = assessmentReminders;
    }

    return json;
  }
}