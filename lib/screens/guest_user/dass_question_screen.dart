import 'dart:math' as math;

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../core/stress_assessment/controllers/assessment_controller.dart';
import '../../data/dass_questions.dart';
import '../../models/dass_model.dart';
import '../../models/stress_assessment_request.dart';
import '../../models/stress_assessment_response.dart';
import '../../theme/app_colors.dart';
import 'dass_result_screen.dart';

class _AnswerOption {
  final String label;
  final String description;

  const _AnswerOption(this.label, this.description);
}

const _answerOptions = [
  _AnswerOption("Not at all", "Didn't apply to me"),
  _AnswerOption("Sometimes", "Applied to some degree"),
  _AnswerOption("Often", "A considerable part of the time"),
  _AnswerOption("Almost always", "Very much, most of the time"),
];

/// Questions are chunked into 3 "chapters" of 7 purely for pacing/progress
/// display — chapters have nothing to do with the DASS-21 subscales, which
/// are interleaved throughout the official item order.
const int _questionsPerChapter = 7;

class StressQuestionnaireScreen extends StatefulWidget {
  const StressQuestionnaireScreen({super.key});

  @override
  State<StressQuestionnaireScreen> createState() =>
      _StressQuestionnaireScreenState();
}

class _StressQuestionnaireScreenState
    extends State<StressQuestionnaireScreen> {
  int currentIndex = 0;
  bool showingChapterBreak = false;

  final Map<int, int> answers = {};

  DassQuestionModel get currentQuestion => dassQuestions[currentIndex];

  bool get isLastQuestion => currentIndex == dassQuestions.length - 1;

  void selectAnswer(int value) {
    setState(() {
      answers[currentQuestion.id] = value;
    });

    // Tap-to-advance: briefly show the selected state, then move on.
    Future.delayed(const Duration(milliseconds: 380), () {
      if (!mounted) return;
      if (answers[currentQuestion.id] != value) return;
      onNext();
    });
  }

  void onNext() {
    if (isLastQuestion) {
      submitAssessment();
      return;
    }

    final nextIndex = currentIndex + 1;

    // A chapter break lands right before the first question of chapters
    // 2 and 3 (i.e. after Q7 and Q14).
    final isChapterBoundary = nextIndex % _questionsPerChapter == 0;

    setState(() {
      currentIndex = nextIndex;
      if (isChapterBoundary) showingChapterBreak = true;
    });
  }

  void onBack() {
    if (currentIndex == 0) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      currentIndex--;
    });
  }

  String get _timeRemainingLabel {
    final remaining = dassQuestions.length - currentIndex - 1;
    final seconds = remaining * 8;
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return "about $minutes:${secs.toString().padLeft(2, '0')} left";
  }

  @override
  Widget build(BuildContext context) {
    if (showingChapterBreak) {
      return _ChapterBreakScreen(
        completedCount: currentIndex,
        totalCount: dassQuestions.length,
        onContinue: () => setState(() => showingChapterBreak = false),
        onBack: () => setState(() {
          showingChapterBreak = false;
          currentIndex--;
        }),
      );
    }

    final selectedValue = answers[currentQuestion.id];

    return Consumer<AssessmentController>(
      builder: (context, assessmentController, child) {
        return BlurryModalProgressHUD(
          inAsyncCall: assessmentController.state.isLoading,
          blurEffectIntensity: 7,
          progressIndicator: SpinKitFadingCircle(
            color: AppColors.dassPrimary,
            size: 90.0.w,
          ),
          dismissible: false,
          opacity: 0.2,
          color: AppColors.blobs1,

          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.dassBgTop, AppColors.dassBgBottom],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                  child: Column(
                    children: [
                      //--------------------------------
                      // Header: back + chapter dots + counter
                      //--------------------------------
                      Row(
                        children: [
                          _backButton(),
                          Expanded(
                            child: Center(child: _buildChapterDots()),
                          ),
                          Text(
                            "${currentIndex + 1}/${dassQuestions.length}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.dassBodyGray,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 22.h),

                      //--------------------------------
                      // Kai asks the question
                      //--------------------------------
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _KaiAvatar(size: 40, asset: 'kai_head.png'),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "KAI ASKS",
                                  style: TextStyle(
                                    fontSize: 10.5.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.dassAccent,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Over the last week…",
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    color: AppColors.dassBodyGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // Fixed-height reservation — question length varies
                      // from one line to four (the longest DASS-21 item
                      // wraps to four), so without a fixed box here the
                      // options below would shift up/down per question.
                      SizedBox(
                        height: 112.h,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              currentQuestion.text,
                              key: ValueKey(currentQuestion.id),
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                                color: AppColors.dassHeadline,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 22.h),

                      //--------------------------------
                      // Options
                      //--------------------------------
                      Expanded(
                        child: ListView.separated(
                          itemCount: _answerOptions.length,
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final option = _answerOptions[index];
                            final selected = selectedValue == index;

                            return GestureDetector(
                              onTap: () => selectAnswer(index),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.dassAccent
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? AppColors.dassAccent
                                            : AppColors.dassLockedBg,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        "$index",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: selected
                                              ? Colors.white
                                              : AppColors.dassHeadline,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 14.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            option.label,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.dassHeadline,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            option.description,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: selected
                                                  ? AppColors.dassAccent
                                                  : AppColors.dassBodyGray,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 6.h),
                      Text(
                        _timeRemainingLabel,
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: AppColors.dassBodyGray,
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: onBack,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back, size: 18, color: AppColors.dassHeadline),
      ),
    );
  }

  Widget _buildChapterDots() {
    final totalChapters =
        (dassQuestions.length / _questionsPerChapter).ceil();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < totalChapters; i++) ...[
          if (i > 0) SizedBox(width: 8.w),
          _ChapterDot(
            number: i + 1,
            // A chapter's dot turns green once the CURRENT question reaches
            // that chapter's last question — matching the reference design,
            // where chapter 2's dot is already green while still answering
            // Q14 (its final question), not only after leaving it.
            completed: currentIndex >= _questionsPerChapter * (i + 1) - 1,
          ),
        ],
      ],
    );
  }

  Future<void> submitAssessment() async {
    final controller = context.read<AssessmentController>();

    final Map<DassSubscale, AssessmentResponse> results = {};

    for (final subscale in DassSubscale.values) {
      final subscaleAnswers = <String, int>{};
      var localId = 1;

      for (final question in dassQuestions.where(
        (q) => q.subscale == subscale,
      )) {
        subscaleAnswers[localId.toString()] = answers[question.id] ?? 0;
        localId++;
      }

      final request = await StressAssessmentRequest.create(
        answers: subscaleAnswers,
        assessmentDefinitionId: subscale.assessmentDefinitionId,
      );

      final success = await controller.submitAssessment(request);

      if (!mounted) return;

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              controller.state.errorMessage ?? "Unable to submit assessment.",
            ),
          ),
        );
        return;
      }

      results[subscale] = controller.state.response!;
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Dass21ResultScreen(results: results)),
    );
  }
}

class _ChapterDot extends StatelessWidget {
  final int number;
  final bool completed;

  const _ChapterDot({required this.number, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: completed ? AppColors.dassAccent : AppColors.dassRingPending,
          width: 2.2,
        ),
      ),
      child: Text(
        "$number",
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: completed ? AppColors.dassAccent : AppColors.dassBodyGray,
        ),
      ),
    );
  }
}

class _KaiAvatar extends StatelessWidget {
  final double size;
  final String asset;

  const _KaiAvatar({required this.size, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      padding: const EdgeInsets.all(2),
      child: ClipOval(
        child: Image.asset('assets/images/mascot/$asset', fit: BoxFit.cover),
      ),
    );
  }
}

//===========================================================================
// Chapter break — WHO stat cards, matching the reference design's
// "4_chapter-1_break" / "5_chapter-2_break" screens.
//===========================================================================

class _ChapterBreakScreen extends StatelessWidget {
  final int completedCount;
  final int totalCount;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const _ChapterBreakScreen({
    required this.completedCount,
    required this.totalCount,
    required this.onContinue,
    required this.onBack,
  });

  int get _chapterNumber => completedCount ~/ _questionsPerChapter;

  @override
  Widget build(BuildContext context) {
    final isChapterOne = _chapterNumber == 1;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.dassBgTop, AppColors.dassBgBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //--------------------------------
                // Header
                //--------------------------------
                Row(
                  children: [
                    Text(
                      "CHAPTER $_chapterNumber COMPLETE",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: AppColors.dassAccent,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "$completedCount of $totalCount",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.dassBodyGray,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: completedCount / totalCount,
                    minHeight: 5,
                    color: AppColors.dassAccent,
                    backgroundColor: AppColors.dassRingPending,
                  ),
                ),

                SizedBox(height: 22.h),

                //--------------------------------
                // Kai + speech bubble
                //--------------------------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _KaiAvatar(size: 64, asset: 'kai_half.png'),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        margin: EdgeInsets.only(top: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          isChapterOne
                              ? "Seven done — that's a third, in about forty seconds."
                              : "Fourteen down. Seven left, then I'll score it.",
                          style: TextStyle(
                            fontSize: 13.sp,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                            color: AppColors.dassHeadline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 26.h),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: isChapterOne ? _barChartViz() : _donutChartViz(),
                  ),
                ),

                //--------------------------------
                // CTA
                //--------------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dassPrimary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isChapterOne
                              ? "Start chapter two"
                              : "Start chapter three",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: GestureDetector(
                    onTap: onBack,
                    child: Text(
                      "Back to the last question",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dassAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _citation() {
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Text(
        "WORLD HEALTH ORGANIZATION",
        style: TextStyle(
          fontSize: 9.5.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: AppColors.dassBodyGray,
        ),
      ),
    );
  }

  Widget _headlineBlock(String headline, String description) {
    return Padding(
      padding: EdgeInsets.only(top: 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headline,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.dassPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 12.5.sp,
              height: 1.4,
              color: AppColors.dassBodyGray,
            ),
          ),
          _citation(),
        ],
      ),
    );
  }

  Widget _barChartViz() {
    const stats = [
      (label: "Anxiety disorders", value: "301M", fraction: 1.0),
      (label: "Depression", value: "280M", fraction: 280 / 301),
      (label: "Bipolar disorder", value: "40M", fraction: 40 / 301),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final stat in stats) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  stat.label,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dassHeadline,
                  ),
                ),
              ),
              Text(
                stat.value,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dassHeadline,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: stat.fraction,
              minHeight: 7,
              color: AppColors.dassPrimary,
              backgroundColor: AppColors.dassSeverityGradient.first,
            ),
          ),
          SizedBox(height: 14.h),
        ],
        _headlineBlock(
          "301 million",
          "people live with an anxiety disorder — more than any other mental health condition on earth.",
        ),
      ],
    );
  }

  Widget _donutChartViz() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 84,
              height: 84,
              child: CustomPaint(
                painter: _DonutPainter(
                  percent: 0.75,
                  trackColor: AppColors.dassSeverityGradient.first,
                  fillColor: AppColors.dassPrimary,
                ),
              ),
            ),
            SizedBox(width: 20.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _legendDot("No treatment", AppColors.dassPrimary),
                SizedBox(height: 8.h),
                _legendDot("Some care", AppColors.dassSeverityGradient.first),
              ],
            ),
          ],
        ),
        _headlineBlock(
          "Over 75%",
          "of people with a mental health condition in lower-income countries get no treatment at all.",
        ),
      ],
    );
  }

  Widget _legendDot(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(fontSize: 12.5.sp, color: AppColors.dassHeadline),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double percent;
  final Color trackColor;
  final Color fillColor;
  static const double strokeWidth = 12;

  _DonutPainter({
    required this.percent,
    required this.trackColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final sweep = 2 * math.pi * percent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.percent != percent ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.fillColor != fillColor;
}
