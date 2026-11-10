enum DassSubscale { depression, anxiety, stress }

extension DassSubscaleX on DassSubscale {
  /// Matches the assessment_definitions.code seeded on the backend —
  /// AssessmentDefinitionSeeder creates depression-v1/anxiety-v1/stress-v1
  /// at ids 2/3/1 respectively.
  int get assessmentDefinitionId => switch (this) {
    DassSubscale.stress => 1,
    DassSubscale.depression => 2,
    DassSubscale.anxiety => 3,
  };

  String get label => switch (this) {
    DassSubscale.depression => 'Depression',
    DassSubscale.anxiety => 'Anxiety',
    DassSubscale.stress => 'Stress',
  };
}

class DassQuestionModel {
  /// Position in the official 21-item DASS-21 order (1-21) — used for the
  /// "X/21" progress display, not for submission.
  final int id;
  final String text;
  final DassSubscale subscale;

  const DassQuestionModel({
    required this.id,
    required this.text,
    required this.subscale,
  });
}
