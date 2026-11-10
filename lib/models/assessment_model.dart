import 'package:flutter/material.dart';

class AssessmentModel {
  final String title;
  final String score;
  final int change;
  final Color scoreColor;

  /// Optional override for the caption line below the score. When null,
  /// falls back to the generic "X from baseline" text derived from [change].
  final String? caption;

  /// Whether to show the up/down/flat trend icon next to the caption.
  final bool showTrendIcon;

  const AssessmentModel({
    required this.title,
    required this.score,
    required this.change,
    required this.scoreColor,
    this.caption,
    this.showTrendIcon = true,
  });

  String get baselineText {
    if (caption != null) return caption!;

    if (change == 0) return "No change";

    return change > 0
        ? "↑ $change from baseline"
        : "↓ ${change.abs()} from baseline";
  }

  Color get changeColor {
    if (change < 0) {
      return const Color(0xff4CAF50);
    }

    if (change > 0) {
      return Colors.red;
    }

    return Colors.grey;
  }
}