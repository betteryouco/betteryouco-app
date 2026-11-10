import 'dart:math' as math;

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_manager.dart';
import '../../core/stress_assessment/controllers/assessment_controller.dart';
import '../../data/screening_instruments.dart';
import '../../models/stress_assessment_request.dart';
import '../../theme/app_colors.dart';
import '../shared/welcome_screen.dart';
import 'screening_result_screen.dart';

/// Question flow for GAD-7 / PHQ-8 — shares the tap-to-select,
/// auto-advance, time-remaining pattern already established for DASS-21
/// (StressQuestionnaireScreen), parameterized by instrument instead of
/// duplicated per assessment. Both instruments are short enough (7-8
/// items) that there's no mid-quiz chapter break — just this screen, then
/// one WHO-stat screen, then results.
class ScreeningQuestionScreen extends StatefulWidget {
  final ScreeningInstrument instrument;

  /// Guests see the program-recommendation panel on the results screen;
  /// premium users (reached via the assessment picker) don't.
  final bool isGuestFlow;

  const ScreeningQuestionScreen({
    super.key,
    required this.instrument,
    required this.isGuestFlow,
  });

  @override
  State<ScreeningQuestionScreen> createState() => _ScreeningQuestionScreenState();
}

class _ScreeningQuestionScreenState extends State<ScreeningQuestionScreen> {
  int currentIndex = 0;
  bool showingStat = false;

  final Map<int, int> answers = {};

  List<String> get items => widget.instrument.items;

  bool get isLastQuestion => currentIndex == items.length - 1;

  void selectAnswer(int value) {
    setState(() => answers[currentIndex] = value);

    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      if (answers[currentIndex] != value) return;
      onNext();
    });
  }

  void onNext() {
    if (isLastQuestion) {
      setState(() => showingStat = true);
      return;
    }
    setState(() => currentIndex++);
  }

  void onBack() {
    if (currentIndex == 0) {
      Navigator.pop(context);
      return;
    }
    setState(() => currentIndex--);
  }

  String get _timeRemainingLabel {
    final remaining = items.length - currentIndex - 1;
    if (remaining <= 0) return "About done";
    final seconds = math.max(5, remaining * 6);
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return "about $minutes:${secs.toString().padLeft(2, '0')} left";
  }

  @override
  Widget build(BuildContext context) {
    if (showingStat) {
      return _ScreeningStatScreen(
        instrument: widget.instrument,
        onContinue: () => submitAssessment(),
        onBack: () => setState(() => showingStat = false),
      );
    }

    final selectedValue = answers[currentIndex];

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
                      Row(
                        children: [
                          _backButton(),
                          Expanded(
                            child: Center(
                              child: Text(
                                "${widget.instrument.instrumentCode} · ${widget.instrument.shortName} screening",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.dassAccent,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "${currentIndex + 1}/${items.length}",
                            style: TextStyle(fontSize: 12.sp, color: AppColors.dassBodyGray),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: (currentIndex + (selectedValue != null ? 1 : 0)) / items.length,
                          minHeight: 5,
                          color: AppColors.dassAccent,
                          backgroundColor: AppColors.dassRingPending,
                        ),
                      ),

                      SizedBox(height: 22.h),

                      SizedBox(
                        height: 112.h,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              items[currentIndex],
                              key: ValueKey(currentIndex),
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

                      SizedBox(height: 12.h),

                      //--------------------------------
                      // Options
                      //--------------------------------
                      Expanded(
                        child: ListView.separated(
                          itemCount: screeningAnswerOptions.length,
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final option = screeningAnswerOptions[index];
                            final selected = selectedValue == index;

                            return GestureDetector(
                              onTap: () => selectAnswer(index),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: selected ? AppColors.dassAccent : Colors.transparent,
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
                                        color: selected ? AppColors.dassAccent : AppColors.dassLockedBg,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        "$index",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: selected ? Colors.white : AppColors.dassHeadline,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 14.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                              color: selected ? AppColors.dassAccent : AppColors.dassBodyGray,
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
                        style: TextStyle(fontSize: 11.5.sp, color: AppColors.dassBodyGray),
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
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: const Icon(Icons.arrow_back, size: 18, color: AppColors.dassHeadline),
      ),
    );
  }

  Future<void> submitAssessment() async {
    final controller = context.read<AssessmentController>();

    final answerMap = <String, int>{};
    for (var i = 0; i < items.length; i++) {
      answerMap[(i + 1).toString()] = answers[i] ?? 0;
    }

    final request = await StressAssessmentRequest.create(
      answers: answerMap,
      assessmentDefinitionId: widget.instrument.assessmentDefinitionId,
    );

    final success = await controller.submitAssessment(request);

    if (!mounted) return;

    if (!success) {
      // The locally-cached login session is no longer valid server-side
      // (expired, or revoked by a backend reset) — retrying this same
      // screen would just fail the same way forever. Send the user to
      // log back in instead of leaving them stuck on a dead-end error.
      if (controller.state.sessionExpired) {
        await SessionManager.instance.logout();
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Your session has expired — please log in again."),
            duration: Duration(seconds: 3),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 1200));
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => WelcomeScreen()),
          (route) => false,
        );
        return;
      }

      setState(() => showingStat = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.state.errorMessage ?? "Unable to submit assessment."),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ScreeningResultScreen(
          instrument: widget.instrument,
          result: controller.state.response!,
          isGuestFlow: widget.isGuestFlow,
        ),
      ),
    );
  }
}

//===========================================================================
// WHO-stat screen shown once, right after the last question — reuses the
// same bar/donut treatment and figures as DASS-21's chapter-break screens.
//===========================================================================

class _ScreeningStatScreen extends StatelessWidget {
  final ScreeningInstrument instrument;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const _ScreeningStatScreen({
    required this.instrument,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
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
                Text(
                  "${instrument.instrumentCode} COMPLETE",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.dassAccent,
                  ),
                ),

                SizedBox(height: 22.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _kaiAvatar(),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                        margin: EdgeInsets.only(top: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          "All done — scoring it now.",
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
                    child: instrument.statVizKind == ScreeningStatVizKind.bars
                        ? _barChartViz()
                        : _donutChartViz(),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dassPrimary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "See my results",
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
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

  Widget _kaiAvatar() {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      padding: const EdgeInsets.all(2),
      child: ClipOval(
        child: Image.asset('assets/images/mascot/kai_half.png', fit: BoxFit.cover),
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
            style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w800, color: AppColors.dassPrimary),
          ),
          SizedBox(height: 6.h),
          Text(
            description,
            style: TextStyle(fontSize: 12.5.sp, height: 1.4, color: AppColors.dassBodyGray),
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
                  style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: AppColors.dassHeadline),
                ),
              ),
              Text(
                stat.value,
                style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: AppColors.dassHeadline),
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
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 8.w),
        Text(label, style: TextStyle(fontSize: 12.5.sp, color: AppColors.dassHeadline)),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double percent;
  final Color trackColor;
  final Color fillColor;
  static const double strokeWidth = 12;

  _DonutPainter({required this.percent, required this.trackColor, required this.fillColor});

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
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, sweep, false, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.percent != percent ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.fillColor != fillColor;
}
