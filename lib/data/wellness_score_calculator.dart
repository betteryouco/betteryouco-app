import 'dart:math';

class WellnessScoreCalculator {
  WellnessScoreCalculator._();

  static int calculate({
    double? bmi,
    int? systolicBP,
    int? diastolicBP,
    int? restingHeartRate,
    double? sleepHours,

    /// Latest DASS-21 raw score (0-42, doubled per the official scoring
    /// convention) for whichever subscale was most recently submitted.
    int? dassScore,
  }) {
    final Map<String, double> weights = {
      'sleep': 30,
      'bp': 25,
      'bmi': 15,
      'hr': 10,
      'dass': 20,
    };

    final Map<String, double> scores = {};

    if (sleepHours != null) {
      scores['sleep'] = _sleepScore(sleepHours);
    }

    if (systolicBP != null && diastolicBP != null) {
      scores['bp'] = _bloodPressureScore(
        systolicBP,
        diastolicBP,
      );
    }

    if (bmi != null) {
      scores['bmi'] = _bmiScore(bmi);
    }

    if (restingHeartRate != null) {
      scores['hr'] = _heartRateScore(restingHeartRate);
    }

    if (dassScore != null) {
      scores['dass'] = _dassScore(dassScore);
    }

    if (scores.isEmpty) {
      return 0;
    }

    final totalWeight = scores.keys.fold<double>(
      0,
          (sum, key) => sum + weights[key]!,
    );

    double weightedScore = 0;

    scores.forEach((key, score) {
      weightedScore +=
          score * (weights[key]! / totalWeight);
    });

    return weightedScore.round().clamp(0, 100);
  }

  // -----------------------------------------------------
  // BMI
  // -----------------------------------------------------

  static double _bmiScore(double bmi) {
    if (bmi >= 18.5 && bmi <= 24.9) return 100;
    if (bmi >= 25 && bmi <= 27.9) return 85;
    if (bmi >= 28 && bmi <= 29.9) return 70;
    if (bmi >= 30 && bmi <= 34.9) return 50;
    if (bmi >= 35) return 30;

    if (bmi >= 17 && bmi < 18.5) return 70;

    return 40;
  }

  // -----------------------------------------------------
  // Blood Pressure
  // -----------------------------------------------------

  static double _bloodPressureScore(
      int systolic,
      int diastolic,
      ) {
    if (systolic < 120 && diastolic < 80) {
      return 100;
    }

    if (systolic <= 129 && diastolic < 80) {
      return 90;
    }

    if ((systolic >= 130 && systolic <= 139) ||
        (diastolic >= 80 && diastolic <= 89)) {
      return 75;
    }

    if ((systolic >= 140 && systolic <= 159) ||
        (diastolic >= 90 && diastolic <= 99)) {
      return 50;
    }

    return 25;
  }

  // -----------------------------------------------------
  // Heart Rate
  // -----------------------------------------------------

  static double _heartRateScore(int bpm) {
    if (bpm >= 60 && bpm <= 75) return 100;
    if (bpm >= 76 && bpm <= 85) return 90;
    if (bpm >= 86 && bpm <= 95) return 75;
    if (bpm >= 96 && bpm <= 110) return 55;
    if (bpm > 110) return 35;
    if (bpm >= 50 && bpm <= 59) return 90;

    return 70;
  }

  // -----------------------------------------------------
  // Sleep
  // -----------------------------------------------------

  static double _sleepScore(double hours) {
    if (hours >= 7 && hours <= 9) return 100;
    if (hours >= 6 && hours < 7) return 85;
    if (hours >= 5 && hours < 6) return 65;
    if (hours >= 4 && hours < 5) return 40;
    if (hours < 4) return 20;
    if (hours > 9 && hours <= 10) return 90;

    return 70;
  }

  // -----------------------------------------------------
  // DASS-21
  // -----------------------------------------------------

  /// DASS-21 subscales are doubled and range 0-42; the official severity
  /// cutoffs differ per subscale (stress/depression/anxiety), so rather
  /// than re-guessing which cutoffs apply here, this treats severity as a
  /// continuous scale — the higher the raw score, the lower its
  /// contribution to overall wellness.
  static double _dassScore(int rawScore) {
    final clamped = rawScore.clamp(0, 42);
    return (100 - (clamped / 42 * 100)).clamp(0, 100).toDouble();
  }

  /// Client-facing "Mental State" label, derived from the severity word
  /// the backend already computed for the most recent DASS-21 submission
  /// (using the instrument's official per-subscale cutoffs) — e.g.
  /// "Moderate Anxiety" -> "Elevated strain".
  static String mentalState(String? interpretation) {
    if (interpretation == null) return "No data yet";

    final band = interpretation.toLowerCase();

    if (band.contains("extremely severe")) return "Very high strain";
    if (band.contains("severe")) return "High strain";
    if (band.contains("moderate")) return "Elevated strain";
    if (band.contains("mild")) return "Mildly strained";
    if (band.contains("normal")) return "Balanced";

    return interpretation;
  }
}