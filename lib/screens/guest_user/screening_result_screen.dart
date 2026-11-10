import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/program/program_service.dart';
import '../../data/screening_instruments.dart';
import '../../models/program_model.dart';
import '../../models/stress_assessment_response.dart';
import '../../theme/app_colors.dart';
import '../shared/signup_screen.dart';
import 'screening_question_screen.dart';

/// Score + band for a completed GAD-7 or PHQ-8. Unlike DASS-21's guest
/// flow, there's a single scalar score here (not three subscales), so
/// there's no partial "locked" mechanic — guests see their full result
/// immediately. Guests additionally see a program-recommendation panel
/// (the same conversion pattern as DASS-21's result screen); premium
/// users, reached via the assessment picker, don't need it.
class ScreeningResultScreen extends StatefulWidget {
  final ScreeningInstrument instrument;
  final AssessmentResponse result;
  final bool isGuestFlow;

  const ScreeningResultScreen({
    super.key,
    required this.instrument,
    required this.result,
    required this.isGuestFlow,
  });

  @override
  State<ScreeningResultScreen> createState() => _ScreeningResultScreenState();
}

class _ScreeningResultScreenState extends State<ScreeningResultScreen> {
  final ProgramService _programService = ProgramService();
  List<ProgramModel> _featuredPrograms = [];
  bool _programsLoading = true;
  int? _selectedProgramId;

  @override
  void initState() {
    super.initState();
    if (widget.isGuestFlow) _loadFeaturedPrograms();
  }

  Future<void> _loadFeaturedPrograms() async {
    try {
      final programs = await _programService.loadFeaturedPrograms();
      if (!mounted) return;
      setState(() {
        _featuredPrograms = programs;
        _selectedProgramId = programs.isNotEmpty ? programs.first.id : null;
        _programsLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _programsLoading = false);
    }
  }

  double get _fraction => (widget.result.score / widget.instrument.maxScore).clamp(0.0, 1.0);

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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //--------------------------------
                // Kai + speech bubble
                //--------------------------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      padding: const EdgeInsets.all(2),
                      child: ClipOval(
                        child: Image.asset('assets/images/mascot/kai_half.png', fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 6.h),
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                        child: Text(
                          "${widget.instrument.instrumentCode} done — here's what I found.",
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

                SizedBox(height: 20.h),

                Text(
                  "${widget.instrument.instrumentCode}: ${widget.result.interpretation.toLowerCase()}",
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: AppColors.dassHeadline),
                ),
                SizedBox(height: 6.h),
                Text(
                  "A screening questionnaire, not a diagnosis — higher isn't a verdict, it's a starting point.",
                  style: TextStyle(fontSize: 12.5.sp, color: AppColors.dassBodyGray),
                ),

                SizedBox(height: 18.h),

                //--------------------------------
                // Score card
                //--------------------------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.instrument.instrumentCode,
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(color: AppColors.dassTan, borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              widget.result.interpretation.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.dassGold,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _severityBar(_fraction),
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              widget.instrument.cardBody,
                              style: TextStyle(fontSize: 11.sp, color: AppColors.dassBodyGray),
                            ),
                          ),
                          Text(
                            "${widget.result.score}",
                            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: AppColors.dassGold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 3.h, left: 2),
                            child: Text(
                              "/${widget.instrument.maxScore}",
                              style: TextStyle(fontSize: 12.sp, color: AppColors.dassBodyGray),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 18.h),

                if (widget.isGuestFlow) ...[
                  _paywallPanel(),
                  SizedBox(height: 14.h),
                ],

                Center(
                  child: OutlinedButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.dassHeadline,
                      side: const BorderSide(color: AppColors.dassRingPending),
                      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      widget.isGuestFlow ? "Take it again" : "Done",
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                SizedBox(height: 14.h),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ScreeningQuestionScreen(
                            instrument: widget.instrument.other,
                            isGuestFlow: widget.isGuestFlow,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Take the ${widget.instrument.other.instrumentCode} →",
                      style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w700, color: AppColors.dassAccent),
                    ),
                  ),
                ),

                SizedBox(height: 18.h),
                Text(
                  "${widget.instrument.disclaimer} If anything here worries you, take it to a GP or therapist — and if you're in crisis, contact your local emergency line now.",
                  style: TextStyle(fontSize: 10.5.sp, color: AppColors.dassBodyGray),
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.instrument.attribution,
                  style: TextStyle(fontSize: 9.sp, height: 1.4, color: AppColors.dassBodyGray),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _severityBar(double fraction) {
    return SizedBox(
      height: 16,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const markerSize = 12.0;
          final trackWidth = constraints.maxWidth;
          final markerX = (trackWidth - markerSize) * fraction;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 5,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: AppColors.dassSeverityGradient
                        .map((c) => Expanded(child: Container(height: 6, color: c)))
                        .toList(),
                  ),
                ),
              ),
              Positioned(
                left: markerX,
                top: 0,
                child: Container(
                  width: markerSize,
                  height: markerSize,
                  decoration: const BoxDecoration(color: AppColors.dassGold, shape: BoxShape.circle),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  //--------------------------------
  // Program recommendation (guest only) — same dynamic, database-driven
  // pattern as Dass21ResultScreen's paywall panel, minus the "locked
  // scales" framing since there's a single score here, not subscales.
  //--------------------------------

  Widget _paywallPanel() {
    final topProgramTitle = _featuredPrograms.isNotEmpty ? _featuredPrograms.first.title : "your matched program";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: AppColors.dassDark, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FREE CLINICAL SCREENING",
            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: AppColors.dassLightGreen, letterSpacing: 0.5),
          ),
          SizedBox(height: 8.h),
          Text(
            "Start a program, get matched",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, height: 1.25, color: Colors.white),
          ),
          SizedBox(height: 10.h),
          Text(
            "Your result points to the $topProgramTitle — a coached plan across sleep, movement, food and stress, then re-test.",
            style: TextStyle(fontSize: 12.5.sp, height: 1.4, color: AppColors.dassLightGreen),
          ),
          SizedBox(height: 18.h),
          if (_programsLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator(color: AppColors.dassLightGreen)),
            )
          else
            for (int i = 0; i < _featuredPrograms.length; i++) ...[
              _programCard(_featuredPrograms[i], isRecommended: i == 0),
              if (i != _featuredPrograms.length - 1) SizedBox(height: 12.h),
            ],
          SizedBox(height: 18.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _featuredPrograms.isEmpty ? null : _startProgram,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dassCream,
                foregroundColor: AppColors.dassHeadline,
                disabledBackgroundColor: AppColors.dassCream.withValues(alpha: 0.4),
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: Text(
                "Start My Transformation",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text(
              "Free 15-minute fit call first · no payment today",
              style: TextStyle(fontSize: 10.sp, color: AppColors.dassLightGreen),
            ),
          ),
        ],
      ),
    );
  }

  void _startProgram() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreen()));
  }

  Widget _programCard(ProgramModel program, {required bool isRecommended}) {
    final selected = _selectedProgramId == program.id;
    final hasPrice = program.price != null && program.price! > 0;
    final priceLabel = hasPrice ? "${program.currency ?? ''} ${program.price!.toStringAsFixed(0)}" : "Custom quote";
    final priceCaption = hasPrice ? "STARTING FROM" : "COMPANY PLANS";
    final priceSuffix = hasPrice ? " /month" : "";

    return GestureDetector(
      onTap: () => setState(() => _selectedProgramId = program.id),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: selected ? 0.45 : 0.14), width: selected ? 1.4 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isRecommended)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(color: AppColors.dassLightGreen, borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "RECOMMENDED FOR YOU",
                          style: TextStyle(fontSize: 8.5.sp, fontWeight: FontWeight.w800, letterSpacing: 0.3, color: AppColors.dassDark),
                        ),
                      ),
                    ),
                  )
                else
                  const Spacer(),
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.dassLightGreen : Colors.transparent,
                    border: Border.all(color: selected ? AppColors.dassLightGreen : Colors.white.withValues(alpha: 0.4), width: 1.4),
                  ),
                  child: selected ? Icon(Icons.check, size: 13, color: AppColors.dassDark) : null,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              program.title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            if (program.tagline != null && program.tagline!.isNotEmpty) ...[
              SizedBox(height: 3.h),
              Text(program.tagline!, style: TextStyle(fontSize: 12.sp, color: AppColors.dassLightGreen)),
            ],
            if (program.highlights.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.1)),
              SizedBox(height: 12.h),
              for (final highlight in program.highlights) ...[
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 14, color: AppColors.dassLightGreen),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          highlight,
                          style: TextStyle(fontSize: 11.5.sp, height: 1.35, color: Colors.white.withValues(alpha: 0.9)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
            SizedBox(height: 6.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(color: AppColors.dassPrimaryLight, borderRadius: BorderRadius.circular(14)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    priceCaption,
                    style: TextStyle(fontSize: 8.5.sp, fontWeight: FontWeight.w700, letterSpacing: 0.3, color: AppColors.dassLightGreen),
                  ),
                  Text.rich(
                    TextSpan(
                      text: priceLabel,
                      style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w800, color: Colors.white),
                      children: [
                        TextSpan(
                          text: priceSuffix,
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500, color: AppColors.dassLightGreen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (program.tags.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                "Best for ${program.tags.join(' · ')}",
                style: TextStyle(fontSize: 10.sp, color: AppColors.dassLightGreen.withValues(alpha: 0.8)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
