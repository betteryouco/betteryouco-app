import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/button_social.dart';
import 'package:betteryou_co/components/measurement_cards.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/core/auth/session_manager.dart';
import 'package:betteryou_co/data/wellness_score_calculator.dart';
import 'package:betteryou_co/models/heart_rate_request.dart';
import 'package:betteryou_co/screens/guest_user/dass_intro_screen.dart';
import 'package:betteryou_co/screens/guest_user/guest_screen.dart';
import 'package:betteryou_co/screens/guest_user/screening_question_screen.dart';
import 'package:betteryou_co/screens/premium_user/assess_screen.dart';
import 'package:betteryou_co/screens/premium_user/expert_screen.dart';
import 'package:betteryou_co/screens/premium_user/health_screen.dart';
import 'package:betteryou_co/screens/premium_user/profile_main_screen.dart';
import 'package:betteryou_co/screens/premium_user/profile_screen.dart';
import 'package:betteryou_co/screens/shared/signup_screen.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../components/app_bottom_nav.dart';
import '../../components/app_fab.dart';
import '../../components/assesment_card.dart';
import '../../components/button_1.dart';
import '../../components/button_2.dart';
import '../../components/form_field.dart';
import '../../components/form_field_label.dart';
import '../../components/gauage_dount.dart';
import '../../components/gauage_dount_2.dart';
import '../../components/health_log_datetime.dart';
import '../../components/health_log_input.dart';
import '../../components/health_log_sheet.dart';
import '../../components/health_log_sheet_header.dart';
import '../../components/summary_card.dart';
import '../../components/task_tile.dart';
import '../../components/text_2.dart';
import '../../components/text_4.dart';
import 'package:intl/intl.dart';

import '../../core/auth/controllers/auth_controller.dart';
import '../../core/health/controllers/health_controller.dart';
import '../../core/profile/ProfileeController.dart';
import '../../core/program/program_controller.dart';
import '../../core/purchase/purchase_controller.dart';
import '../../core/stress_assessment/controllers/assessment_controller.dart';
import '../../data/screening_instruments.dart';
import '../../models/assessment_model.dart';
import '../../models/blood_pressure_request.dart';
import '../../models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  int selectedIndex = 0;

  final GlobalKey<HealthScreenState> healthKey = GlobalKey<HealthScreenState>();
  final GlobalKey<AssessScreenState> assessKey = GlobalKey<AssessScreenState>();
  final GlobalKey<ExpertScreenState> expertKey = GlobalKey<ExpertScreenState>();
  final GlobalKey<ProfileScreenState> profileKey =
      GlobalKey<ProfileScreenState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthController>(
      builder: (context, healthController, child) {
        final summary = healthController.state.summary;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: AppBackground(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
              child: IndexedStack(
                index: selectedIndex,
                children: [
                  HealthScreen(key: healthKey),
                  AssessScreen(key: assessKey),
                  ExpertScreen(key: expertKey),
                  ProfileMainScreen(key: profileKey),
                ],
              ),
            ),
          ),
          extendBody: true,
          bottomNavigationBar: Container(
            color: Colors.transparent,
            height: 76,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AppBottomNav(
                    selectedIndex: selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        selectedIndex = index;
                      });

                      // Refetch that tab's data every time it's selected,
                      // so switching tabs always shows the latest state
                      // from the API rather than a stale first-load snapshot.
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        switch (index) {
                          case 0:
                            context.read<HealthController>().loadSummary(DateTime.now());
                            break;
                          case 1:
                            context.read<AssessmentController>().loadDashboard();
                            context.read<AssessmentController>().loadInstrumentTrend();
                            break;
                          case 2:
                            context.read<ProgramController>().loadAllPrograms();
                            context.read<PurchaseController>().loadMyEnrollments();
                            break;
                          case 3:
                            context.read<ProfileeController>().loadSummary();
                            break;
                        }
                      });
                    },
                  ),
                ),

                if (selectedIndex != 2)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: AppFab(
                      onPressed: () {
                        if (selectedIndex == 0) {
                          healthKey.currentState?.showBottomSheet(context);
                        } else if (selectedIndex == 1) {
                          _showAssessmentPicker(context);
                        } else if (selectedIndex == 3) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    geta();
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthController>().loadSummary(selectedDate);
    });*/
  }

  geta() async {
    final user = await SessionManager.instance.getUser();
  }

  /// Premium users now choose which assessment to take — previously the
  /// FAB opened DASS-21 directly. Follows the same picker pattern as the
  /// Blood Pressure / Heart Rate options in HealthScreen.showBottomSheet.
  void _showAssessmentPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.7),
      isScrollControlled: true,
      backgroundColor: const Color(0xFFECECEC),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(sheetContext),
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: const Center(child: Icon(Icons.close, size: 24)),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  const Text(
                    "Take an Assessment",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              const Text(
                "Choose which screening you'd like to take.",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              MeasurementCard(
                "DASS-21",
                "Depression, anxiety and stress — 21 questions, ~3 minutes",
                "🧭",
                () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DassIntroScreen()),
                  );
                },
              ),
              MeasurementCard(
                "GAD-7",
                "Anxiety and worry — 7 questions, ~1 minute",
                "🫧",
                () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScreeningQuestionScreen(
                        instrument: ScreeningInstrument.gad7,
                        isGuestFlow: false,
                      ),
                    ),
                  );
                },
              ),
              MeasurementCard(
                "PHQ-8",
                "Mood and depression — 8 questions, ~1 minute",
                "🌤️",
                () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScreeningQuestionScreen(
                        instrument: ScreeningInstrument.phq8,
                        isGuestFlow: false,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
