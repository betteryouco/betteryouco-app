import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/app_bottom_nav_2.dart';
import 'package:betteryou_co/components/button_social.dart';
import 'package:betteryou_co/components/measurement_cards.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/core/auth/session_manager.dart';
import 'package:betteryou_co/data/wellness_score_calculator.dart';
import 'package:betteryou_co/models/heart_rate_request.dart';
import 'package:betteryou_co/screens/expert_user/expert_home_screen.dart';
import 'package:betteryou_co/screens/expert_user/expert_profile_screen.dart';
import 'package:betteryou_co/screens/guest_user/dass_question_screen.dart';
import 'package:betteryou_co/screens/guest_user/guest_screen.dart';
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
import '../../core/auth/controllers/auth_controller.dart';
import '../../core/client/client_controller.dart';
import '../../core/health/controllers/health_controller.dart';
import '../../core/messaging/conversation_controller.dart';
import '../../core/profile/ProfileeController.dart';
import '../../core/program/program_controller.dart';
import '../../core/specialist_dashboard/specialist_dashboard_controller.dart';
import '../../core/stress_assessment/controllers/assessment_controller.dart';
import '../../models/assessment_model.dart';
import '../../models/blood_pressure_request.dart';
import '../../models/task_model.dart';
import 'expert_clients_screen.dart';
import 'expert_messages_screen.dart';
import 'expert_programs_screen.dart';

class ExpertMainScreen extends StatefulWidget {
  const ExpertMainScreen({super.key});

  @override
  State<ExpertMainScreen> createState() => _ExpertMainScreenState();
}

class _ExpertMainScreenState extends State<ExpertMainScreen> {
  int currentIndex = 0;
  int selectedIndex = 0;

  final GlobalKey<ExpertHomeScreenState> homeKey = GlobalKey<ExpertHomeScreenState>();
  final GlobalKey<ExpertProfileScreenState> profileKey = GlobalKey<ExpertProfileScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
          child: IndexedStack(
            index: selectedIndex,
            children: [
              ExpertHomeScreen(key: homeKey),
              const ExpertClientsScreen(),
              const ExpertProgramsScreen(),
              const ExpertMessagesScreen(),
              ExpertProfileScreen(key: profileKey),
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        height: 76,
        child: AppBottomNav2(
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            setState(() {
              selectedIndex = index;
            });

            if (index == 0) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<SpecialistDashboardController>().loadDashboard();
              });
            }

            if (index == 1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ClientController>().loadActiveClients();
              });
            }

            if (index == 2) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ProgramController>().loadMyPrograms();
              });
            }

            if (index == 3) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ConversationController>().loadSpecialistConversations();
              });
            }

            if (index == 4) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                // populateData() must run AFTER the fetch resolves, not
                // alongside it — calling it synchronously here populated
                // the form fields from whatever (possibly stale/null)
                // profile was already in state, and nothing re-populated
                // them once the fresh fetch actually completed.
                await context.read<ProfileeController>().loadSpecialistProfile();
                profileKey.currentState?.populateData();
              });
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();


    // geta();
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthController>().loadSummary(selectedDate);
    });*/
  }

  geta() async {
    final user = await SessionManager.instance.getUser();
  }
}
