import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/feature_card_2.dart';
import 'package:betteryou_co/screens/guest_user/bmi_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/feature_card.dart';
import '../../data/screening_instruments.dart';
import '../../theme/app_colors.dart';
import '../shared/signup_screen.dart';
import 'screening_question_screen.dart';

/// Guest home screen — guests may only take GAD-7 / PHQ-8 (DASS-21 now
/// requires clinical supervision, so it's premium-only, reached via the
/// assessment picker on the FAB). Matches figma_ui_screens/guest/
/// guest_home_new1.png (nothing selected) and guest_home_new2.png
/// (GAD-7 selected).
class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});

  @override
  State<GuestScreen> createState() => _GuestScreenState();
}

class _GuestScreenState extends State<GuestScreen> {
  ScreeningInstrument? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AppBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, size: 13.sp, color: AppColors.dassAccent),
                    SizedBox(width: 4.w),
                    Text(
                      "Free Clinical Screening",
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.dassAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  "Know your anxiety and\nmood score in 3 minutes",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    color: AppColors.dassHeadline,
                  ),
                ),
                SizedBox(height: 20.h),

                //--------------------------------
                // Instrument cards
                //--------------------------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _instrumentCard(ScreeningInstrument.gad7)),
                    SizedBox(width: 12.w),
                    Expanded(child: _instrumentCard(ScreeningInstrument.phq8)),
                  ],
                ),

                SizedBox(height: 20.h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selected == null ? null : _startSelected,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dassAccent,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFE6E0DA),
                      disabledForegroundColor: const Color(0xFF9A938C),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: Text(
                      _selected == null ? "Start free assessment" : "Start the ${_selected!.instrumentCode}",
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  _selected == null ? "Select an assessment above to begin" : "No account required · About a minute",
                  style: TextStyle(fontSize: 12.sp, color: AppColors.dassBodyGray),
                ),

                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Also Available",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.dassHeadline),
                  ),
                ),
                SizedBox(height: 8.h),
                FeatureCard(
                  title: "BMI Calculator",
                  description: "Quick body mass index check with clinical context and next steps.",
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (_) => BMICalculatorSheet(),
                    );
                  },
                ),
                SizedBox(height: 12.h),
                FeatureCard(
                  title: "Meet Our Specialists",
                  description: "Browse verified dietitians, psychologists, trainers, and coaches.",
                  onTap: () {
                    // Specialist browsing is an authenticated-only feature
                    // (see ExpertScreen) — route guests through signup
                    // rather than leaving this tap silently do nothing.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupScreen()),
                    );
                  },
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "How BetterYouCo Works",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.dassHeadline),
                  ),
                ),
                SizedBox(height: 8.h),
                FeatureCard2(
                  title: "Take a free screening",
                  description: "The GAD-7 or the PHQ-8, about a minute, no signup.",
                  num: "1",
                ),
                SizedBox(height: 12.h),
                FeatureCard2(
                  title: "Get matched with a specialist",
                  description: "Verified dietitians, psychologists and coaches, picked for your result.",
                  num: "2",
                ),
                SizedBox(height: 12.h),
                FeatureCard2(
                  title: "Transform in 8 weeks",
                  description: "A coached plan across sleep, movement, food and stress — then re-test.",
                  num: "3",
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.dassFreeBadgeBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Average GAD-7 drop: 5 points",
                    style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: AppColors.dassPrimary),
                  ),
                ),

                SizedBox(height: 24.h),
                Text(
                  "Screening questionnaires, not diagnoses.",
                  style: TextStyle(fontSize: 11.sp, color: AppColors.dassBodyGray),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _instrumentCard(ScreeningInstrument instrument) {
    final selected = _selected == instrument;

    return GestureDetector(
      onTap: () => setState(() => _selected = instrument),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFBFDF8) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.dassAccent : const Color(0xFFE8E2DC), width: selected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(color: AppColors.dassTan, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      instrument.instrumentCode,
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: AppColors.dassGold),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.dassAccent : Colors.transparent,
                    border: Border.all(color: selected ? AppColors.dassAccent : const Color(0xFFDAD3CC), width: 1.5),
                  ),
                  child: selected ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              instrument.cardTitle,
              style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w800, color: AppColors.dassHeadline),
            ),
            SizedBox(height: 4.h),
            Text(
              instrument.cardBody,
              style: TextStyle(fontSize: 11.sp, height: 1.35, color: AppColors.dassBodyGray),
            ),
            SizedBox(height: 10.h),
            Container(height: 1, color: const Color(0xFFEDE8E2)),
            SizedBox(height: 8.h),
            Text(
              instrument.cardMeta,
              style: TextStyle(fontSize: 10.sp, color: AppColors.dassBodyGray),
            ),
          ],
        ),
      ),
    );
  }

  void _startSelected() {
    final instrument = _selected;
    if (instrument == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScreeningQuestionScreen(instrument: instrument, isGuestFlow: true),
      ),
    );
  }
}
