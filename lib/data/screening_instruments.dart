/// GAD-7 and PHQ-8 — short, self-contained screenings introduced to
/// replace guest access to DASS-21 (which now requires clinical
/// supervision). Both instruments share the same official 0-3 Likert
/// answer scale; only the items, id, and severity bands differ.
///
/// assessmentDefinitionId matches AssessmentDefinitionSeeder's
/// gad7-v1 (id 4) / phq8-v1 (id 5) rows on the backend.
enum ScreeningInstrument { gad7, phq8 }

class ScreeningAnswerOption {
  final String label;
  final String description;

  const ScreeningAnswerOption(this.label, this.description);
}

/// The official GAD-7/PHQ response scale — distinct from DASS-21's own
/// "Not at all / Sometimes / Often / Almost always" wording.
const screeningAnswerOptions = [
  ScreeningAnswerOption("Not at all", "None of the last 14 days"),
  ScreeningAnswerOption("Several days", "Roughly 1–6 days"),
  ScreeningAnswerOption("More than half the days", "Roughly 7–11 days"),
  ScreeningAnswerOption("Nearly every day", "12 days or more"),
];

enum ScreeningStatVizKind { bars, donut }

extension ScreeningInstrumentX on ScreeningInstrument {
  int get assessmentDefinitionId => switch (this) {
    ScreeningInstrument.gad7 => 4,
    ScreeningInstrument.phq8 => 5,
  };

  String get instrumentCode => switch (this) {
    ScreeningInstrument.gad7 => "GAD-7",
    ScreeningInstrument.phq8 => "PHQ-8",
  };

  /// e.g. "anxiety" / "depression" — used in kicker text like
  /// "GAD-7 · anxiety screening".
  String get shortName => switch (this) {
    ScreeningInstrument.gad7 => "anxiety",
    ScreeningInstrument.phq8 => "depression",
  };

  String get cardTitle => switch (this) {
    ScreeningInstrument.gad7 => "Anxiety & Worry",
    ScreeningInstrument.phq8 => "Mood & Depression",
  };

  String get cardBody => switch (this) {
    ScreeningInstrument.gad7 =>
      "Excessive worry, nervousness, restlessness, trouble relaxing and fear.",
    ScreeningInstrument.phq8 =>
      "Low mood, less interest or enjoyment, tiredness, sleep or appetite changes, poor focus.",
  };

  String get cardMeta => switch (this) {
    ScreeningInstrument.gad7 => "7 questions · 0–21",
    ScreeningInstrument.phq8 => "8 questions · 0–24",
  };

  int get maxScore => switch (this) {
    ScreeningInstrument.gad7 => 21,
    ScreeningInstrument.phq8 => 24,
  };

  String get disclaimer => "A screening questionnaire, not a diagnosis.";

  String get attribution => switch (this) {
    ScreeningInstrument.gad7 =>
      "GAD-7 © Original developers: Spitzer, Kroenke, Williams and Löwe. Developed with an educational grant from Pfizer Inc. Used without modification.",
    ScreeningInstrument.phq8 =>
      "PHQ-8 © Original developers: Spitzer, Williams, Kroenke and colleagues. Developed with an educational grant from Pfizer Inc. Used without modification.",
  };

  ScreeningStatVizKind get statVizKind => switch (this) {
    ScreeningInstrument.gad7 => ScreeningStatVizKind.bars,
    ScreeningInstrument.phq8 => ScreeningStatVizKind.donut,
  };

  ScreeningInstrument get other => switch (this) {
    ScreeningInstrument.gad7 => ScreeningInstrument.phq8,
    ScreeningInstrument.phq8 => ScreeningInstrument.gad7,
  };

  List<String> get items => switch (this) {
    ScreeningInstrument.gad7 => const [
      "Feeling nervous, anxious, or on edge",
      "Not being able to stop or control worrying",
      "Worrying too much about different things",
      "Trouble relaxing",
      "Being so restless that it's hard to sit still",
      "Becoming easily annoyed or irritable",
      "Feeling afraid as if something awful might happen",
    ],
    ScreeningInstrument.phq8 => const [
      "Little interest or pleasure in doing things",
      "Feeling down, depressed, or hopeless",
      "Trouble falling or staying asleep, or sleeping too much",
      "Feeling tired or having little energy",
      "Poor appetite or overeating",
      "Feeling bad about yourself — or that you're a failure, or have let yourself or your family down",
      "Trouble concentrating on things, such as reading or watching television",
      "Moving or speaking so slowly that other people noticed — or the opposite, being fidgety and restless",
    ],
  };
}
