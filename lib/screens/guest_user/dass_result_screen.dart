import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/auth/session_manager.dart';
import '../../core/program/program_service.dart';
import '../../models/dass_model.dart';
import '../../models/program_model.dart';
import '../../models/stress_assessment_response.dart';
import '../../theme/app_colors.dart';
import '../shared/signup_screen.dart';

class _SubscaleInfo {
  final String cutoffLabel;
  final String description;

  const _SubscaleInfo(this.cutoffLabel, this.description);
}

const _subscaleInfo = {
  DassSubscale.depression: _SubscaleInfo(
    "Normal up to 9",
    "Low mood, loss of interest, hopelessness and a flat sense of the future.",
  ),
  DassSubscale.anxiety: _SubscaleInfo(
    "Normal up to 7",
    "Physical arousal — racing heart, shaky hands — plus fear and panic.",
  ),
  DassSubscale.stress: _SubscaleInfo(
    "Normal up to 14",
    "Tension, irritability and difficulty switching off or relaxing.",
  ),
};

/// Subscales that stay locked for a guest (unauthenticated) user.
/// Matches the client wireframe exactly: Depression is free, Anxiety and
/// Stress sit behind the "full report".
const _guestLockedSubscales = {DassSubscale.anxiety, DassSubscale.stress};

class Dass21ResultScreen extends StatefulWidget {
  final Map<DassSubscale, AssessmentResponse> results;

  const Dass21ResultScreen({super.key, required this.results});

  @override
  State<Dass21ResultScreen> createState() => _Dass21ResultScreenState();
}

class _Dass21ResultScreenState extends State<Dass21ResultScreen> {
  bool? isPremium;
  final ProgramService _programService = ProgramService();
  List<ProgramModel> _featuredPrograms = [];
  bool _programsLoading = true;
  int? _selectedProgramId;

  @override
  void initState() {
    super.initState();
    _checkSession();
    _loadFeaturedPrograms();
  }

  Future<void> _checkSession() async {
    final loggedIn = await SessionManager.instance.hasToken();
    if (!mounted) return;
    setState(() => isPremium = loggedIn);
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

  bool _isLocked(DassSubscale subscale) {
    if (isPremium == true) return false;
    return _guestLockedSubscales.contains(subscale);
  }

  bool get _anyLocked => DassSubscale.values.any((s) => _isLocked(s));

  int get _lockedCount =>
      DassSubscale.values.where((s) => _isLocked(s)).length;

  @override
  Widget build(BuildContext context) {
    // Session check still in flight — avoid flashing the locked state if
    // the user turns out to be logged in.
    if (isPremium == null) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.dassBgTop, AppColors.dassBgBottom],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.dassPrimary),
        ),
      );
    }

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
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/mascot/kai_half.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 6.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          _anyLocked
                              ? "All 21 answered — nice work. Here's what I found."
                              : "All three scales are open — here's your full report.",
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
                  _anyLocked ? "One scale, on the house" : "Your week, scored",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dassHeadline,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  _anyLocked
                      ? "Depression is unlocked below. Anxiety and stress sit behind the full report."
                      : "Three separate scales, each with its own severity band. Higher isn't a verdict — it's a starting point.",
                  style: TextStyle(fontSize: 12.5.sp, color: AppColors.dassBodyGray),
                ),

                SizedBox(height: 18.h),

                //--------------------------------
                // Summary tiles
                //--------------------------------
                Row(
                  children: DassSubscale.values
                      .map((s) => Expanded(child: _summaryTile(s)))
                      .toList(),
                ),

                SizedBox(height: 18.h),

                //--------------------------------
                // Detail cards
                //--------------------------------
                ...DassSubscale.values.map((s) {
                  return _isLocked(s) ? _lockedCard() : _detailCard(s);
                }),

                if (_anyLocked) ...[
                  SizedBox(height: 6.h),
                  _paywallPanel(),
                  SizedBox(height: 14.h),
                  Center(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.dassHeadline,
                        side: const BorderSide(color: AppColors.dassRingPending),
                        padding: EdgeInsets.symmetric(
                          horizontal: 28.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Take it again",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 18.h),
                Text(
                  "The DASS-21 is a screening questionnaire, not a diagnosis. If anything here worries you, take it to a GP or therapist — and if you're in crisis, contact your local emergency line now.",
                  style: TextStyle(fontSize: 10.5.sp, color: AppColors.dassBodyGray),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryTile(DassSubscale subscale) {
    final locked = _isLocked(subscale);
    final response = widget.results[subscale];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: locked ? AppColors.dassLockedBg : AppColors.dassTan,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            subscale.label.toUpperCase(),
            style: TextStyle(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w800,
              color: locked ? AppColors.dassBodyGray : AppColors.dassGold,
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            locked ? "Locked" : _severityWord(subscale, response),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: locked ? AppColors.dassBodyGray : AppColors.dassHeadline,
            ),
          ),
        ],
      ),
    );
  }

  String _severityWord(DassSubscale subscale, AssessmentResponse? response) {
    final interpretation = response?.interpretation ?? "—";
    return interpretation.replaceAll(subscale.label, "").trim().isEmpty
        ? interpretation
        : interpretation.replaceAll(subscale.label, "").trim();
  }

  Widget _detailCard(DassSubscale subscale) {
    final response = widget.results[subscale];
    final info = _subscaleInfo[subscale]!;
    final score = response?.score ?? 0;
    final fraction = (score / 42).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  subscale.label,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.dassTan,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _severityWord(subscale, response).toUpperCase(),
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
          _severityBar(fraction),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  info.cutoffLabel,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.dassBodyGray),
                ),
              ),
              Text(
                "$score",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.dassGold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3.h, left: 2),
                child: Text(
                  "/42",
                  style: TextStyle(fontSize: 12.sp, color: AppColors.dassBodyGray),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 1, color: AppColors.dassLockedBg),
          SizedBox(height: 12.h),
          Text(
            info.description,
            style: TextStyle(fontSize: 12.5.sp, height: 1.4, color: AppColors.dassBodyGray),
          ),
        ],
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
          final markerX =
              (trackWidth - markerSize) * fraction;

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
                  decoration: const BoxDecoration(
                    color: AppColors.dassGold,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _lockedCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Faint placeholder content, standing in for the hidden card.
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 90,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.dassLockedBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: 18.h),
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.dassLockedBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: 14.h),
                Container(
                  width: 140,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.dassLockedBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
          // Frosted blur over the placeholder content.
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.white.withValues(alpha: 0.35)),
          ),
          // Lock pill badge.
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.dassAccent, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, size: 8, color: AppColors.dassAccent),
                SizedBox(width: 8.w),
                Text(
                  "LOCKED",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.dassAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paywallPanel() {
    final topProgramTitle =
        _featuredPrograms.isNotEmpty ? _featuredPrograms.first.title : "your matched program";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.dassDark,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$_lockedCount OF ${DassSubscale.values.length} SCALES LOCKED",
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.dassLightGreen,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Start a program, open the report",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              height: 1.25,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            "Your score points to the $topProgramTitle — start there and the full report unlocks with it.",
            style: TextStyle(
              fontSize: 12.5.sp,
              height: 1.4,
              color: AppColors.dassLightGreen,
            ),
          ),
          SizedBox(height: 18.h),
          if (_programsLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.dassLightGreen),
              ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SignupScreen()),
    );
  }

  Widget _programCard(ProgramModel program, {required bool isRecommended}) {
    final selected = _selectedProgramId == program.id;
    final hasPrice = program.price != null && program.price! > 0;
    final priceLabel = hasPrice
        ? "${program.currency ?? ''} ${program.price!.toStringAsFixed(0)}"
        : "Custom quote";
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
          border: Border.all(
            color: Colors.white.withValues(alpha: selected ? 0.45 : 0.14),
            width: selected ? 1.4 : 1,
          ),
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
                        decoration: BoxDecoration(
                          color: AppColors.dassLightGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "RECOMMENDED FOR YOU",
                          style: TextStyle(
                            fontSize: 8.5.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                            color: AppColors.dassDark,
                          ),
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
                    border: Border.all(
                      color: selected ? AppColors.dassLightGreen : Colors.white.withValues(alpha: 0.4),
                      width: 1.4,
                    ),
                  ),
                  child: selected
                      ? Icon(Icons.check, size: 13, color: AppColors.dassDark)
                      : null,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              program.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            if (program.tagline != null && program.tagline!.isNotEmpty) ...[
              SizedBox(height: 3.h),
              Text(
                program.tagline!,
                style: TextStyle(fontSize: 12.sp, color: AppColors.dassLightGreen),
              ),
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
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            height: 1.35,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
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
              decoration: BoxDecoration(
                color: AppColors.dassPrimaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    priceCaption,
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      color: AppColors.dassLightGreen,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: priceLabel,
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: priceSuffix,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.dassLightGreen,
                          ),
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
