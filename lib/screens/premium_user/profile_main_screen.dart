import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/button_social.dart';
import 'package:betteryou_co/components/measurement_cards.dart';
import 'package:betteryou_co/components/profile_card.dart';
import 'package:betteryou_co/components/profile_card_noti.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/core/auth/session_manager.dart';
import 'package:betteryou_co/core/stress_assessment/controllers/assessment_controller.dart';
import 'package:betteryou_co/data/wellness_score_calculator.dart';
import 'package:betteryou_co/models/heart_rate_request.dart';
import 'package:betteryou_co/screens/guest_user/dass_question_screen.dart';
import 'package:betteryou_co/screens/guest_user/guest_screen.dart';
import 'package:betteryou_co/screens/premium_user/expert_detail_screen.dart';
import 'package:betteryou_co/screens/shared/signup_screen.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../components/app_bottom_nav.dart';
import '../../components/app_fab.dart';
import '../../components/assesment_card.dart';
import '../../components/button_1.dart';
import '../../components/button_2.dart';
import '../../components/chart_card.dart';
import '../../components/expert_profile_card.dart';
import '../../components/form_field.dart';
import '../../components/form_field_label.dart';
import '../../components/gauage_dount.dart';
import '../../components/gauage_dount_2.dart';
import '../../components/health_line_chart.dart';
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
import '../../core/purchase/purchase_controller.dart';
import '../../models/assessment_model.dart';
import '../../models/blood_pressure_request.dart';
import '../../models/chart_point_dass.dart';
import '../../models/profile_request.dart';
import '../../models/task_model.dart';
import 'profile_screen.dart';

class ProfileMainScreen extends StatefulWidget {
  const ProfileMainScreen({super.key});

  @override
  State<ProfileMainScreen> createState() => ProfileMainScreenState();
}

class ProfileMainScreenState extends State<ProfileMainScreen> {
  String name = "Loading...";
  String email = "Loading...";

  final _pushNotifier = ValueNotifier<bool>(false);
  final _emailNotifier = ValueNotifier<bool>(false);
  final _sessionNotifier = ValueNotifier<bool>(false);
  final _assessmentNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AssessmentController, PurchaseController>(
      builder: (context, assessmentController, purchaseController, child) {
        return BlurryModalProgressHUD(
          inAsyncCall: assessmentController.state.isLoading,
          blurEffectIntensity: 7,
          progressIndicator: SpinKitFadingCircle(
            color: AppColors.primaryBtn,
            size: 90.0.w,
          ),
          dismissible: false,
          opacity: 0.2,
          color: AppColors.blobs1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileCard(email: email, name: name, imageUrl: ""),

                SizedBox(height: 24),
                Text4("Subscription"),
                SizedBox(height: 8),
                Builder(builder: (context) {
                  final enrollments = purchaseController.state.enrollments;
                  final enrollment = enrollments.isNotEmpty ? enrollments.first : null;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFFFFFF), // White
                          Color(0xFFFFEAD1), // Soft Peach
                          Color(0xFFF9DCFB),
                          Color(0xFFF9DCFB),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: enrollment == null
                          ? [
                              Text2("No active program"),
                              Text4("Browse the Experts tab to get started"),
                            ]
                          : [
                              Text2(enrollment.assignmentStatus.label),
                              Text4(enrollment.program?.title ?? "Program"),
                              if (enrollment.pricePaid != null)
                                Text2(
                                  "${enrollment.currency ?? ''} ${enrollment.pricePaid!.toStringAsFixed(0)}"
                                  "${enrollment.specialist != null ? ' · ${enrollment.specialist!.name}' : ''}",
                                ),
                            ],
                    ),
                  );
                }),

                SizedBox(height: 24),
                Text4("Account"),
                SizedBox(height: 8),

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: _editProfile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 24,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Edit Profile",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.headingText,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 8),
                ProfileCardNotification(
                  title: "Push Notifications",
                  icon: "assets/images/profile_notification.png",
                  controller: _pushNotifier,
                  onTap: (v) => _updatePreference(
                    pushNotifications: v,
                  ),
                ),
                SizedBox(height: 8),
                ProfileCardNotification(
                  title: "Email Updates",
                  icon: "assets/images/profile_email.png",
                  controller: _emailNotifier,
                  onTap: (v) => _updatePreference(
                    emailUpdates: v,
                  ),
                ),
                SizedBox(height: 8),
                ProfileCardNotification(
                  title: "Session Reminders",
                  icon: "assets/images/profile_notification.png",
                  controller: _sessionNotifier,
                  onTap: (v) => _updatePreference(
                    sessionReminders: v,
                  ),
                ),
                SizedBox(height: 8),
                ProfileCardNotification(
                  title: "Assessment Reminders",
                  icon: "assets/images/profile_assessmet.png",
                  controller: _assessmentNotifier,
                  onTap: (v) => _updatePreference(
                    assessmentReminders: v,
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

    getUser();
    loadPreferences();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurchaseController>().loadMyEnrollments();
    });
  }

  @override
  void dispose() {
    _pushNotifier.dispose();
    _emailNotifier.dispose();
    _sessionNotifier.dispose();
    _assessmentNotifier.dispose();
    super.dispose();
  }

  getUser() async {
    final user = await SessionManager.instance.getUser();

    if (!mounted) return;

    setState(() {
      name = user?['name'] ?? "No Name";
      email = user?['email'] ?? "No Email";
    });
  }

  Future<void> loadPreferences() async {
    final controller = context.read<ProfileeController>();
    await controller.loadSummary();

    final profile = controller.state.summary;
    if (profile == null) return;

    _pushNotifier.value = profile.pushNotifications;
    _emailNotifier.value = profile.emailUpdates;
    _sessionNotifier.value = profile.sessionReminders;
    _assessmentNotifier.value = profile.assessmentReminders;
  }

  Future<void> _updatePreference({
    bool? pushNotifications,
    bool? emailUpdates,
    bool? sessionReminders,
    bool? assessmentReminders,
  }) async {
    final controller = context.read<ProfileeController>();

    await controller.completeProfile(
      CompleteProfileRequest(
        pushNotifications: pushNotifications,
        emailUpdates: emailUpdates,
        sessionReminders: sessionReminders,
        assessmentReminders: assessmentReminders,
      ),
    );
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }
}
