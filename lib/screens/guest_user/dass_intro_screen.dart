import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import 'dass_question_screen.dart';

/// The DASS-21 welcome screen — the first thing a user sees before the
/// question flow starts. Matches the reference design's "1_intro_screen".
class DassIntroScreen extends StatelessWidget {
  const DassIntroScreen({super.key});

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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //--------------------------------
                // Badges
                //--------------------------------
                Row(
                  children: [
                    _badge("CLINICAL SCREENING", AppColors.dassFreeBadgeBg, AppColors.dassPrimary),
                    SizedBox(width: 8.w),
                    _badge(
                      "SUPERVISED",
                      AppColors.dassMauveBadgeBg,
                      AppColors.dassMauveBadgeText,
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                //--------------------------------
                // Headline
                //--------------------------------
                Text(
                  "Know your stress score in 3 minutes",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    color: AppColors.dassHeadline,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "21 short statements about your last seven days, asked one at a time.",
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    height: 1.4,
                    color: AppColors.dassBodyGray,
                  ),
                ),

                SizedBox(height: 18.h),

                //--------------------------------
                // Speech bubble
                //--------------------------------
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Hi, I'm Kai. I'll ask — you just tap the answer that fits.",
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: AppColors.dassHeadline,
                    ),
                  ),
                ),

                const Spacer(),

                //--------------------------------
                // Kai — full body
                //--------------------------------
                Center(
                  child: Container(
                    width: 176.w,
                    height: 176.w,
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/mascot/kai_full.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                //--------------------------------
                // CTA
                //--------------------------------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StressQuestionnaireScreen(),
                        ),
                      );
                    },
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
                          "Start with Kai",
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
                  child: Text(
                    "Nothing leaves your phone.",
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: AppColors.dassBodyGray,
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

  Widget _badge(String label, Color bg, Color fg) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: fg,
        ),
      ),
    );
  }
}
