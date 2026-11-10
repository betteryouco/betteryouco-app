import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/button_social.dart';
import 'package:betteryou_co/components/measurement_cards.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/core/auth/session_manager.dart';
import 'package:betteryou_co/core/stress_assessment/controllers/assessment_controller.dart';
import 'package:betteryou_co/data/wellness_score_calculator.dart';
import 'package:betteryou_co/models/heart_rate_request.dart';
import 'package:betteryou_co/screens/guest_user/dass_question_screen.dart';
import 'package:betteryou_co/screens/guest_user/guest_screen.dart';
import 'package:betteryou_co/screens/premium_user/expert_detail_screen.dart';
import 'package:betteryou_co/screens/premium_user/program_checkout_screen.dart';
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
import '../../components/chart_card.dart';
import '../../components/expert_profile_card.dart';
import '../../components/program_card.dart';
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
import '../../core/program/program_controller.dart';
import '../../core/program/program_state.dart';
import '../../core/purchase/purchase_controller.dart';
import '../../models/assessment_model.dart';
import '../../models/blood_pressure_request.dart';
import '../../models/chart_point_dass.dart';
import '../../models/enrollment_model.dart';
import '../../models/program_model.dart';
import '../../models/task_model.dart';
import 'my_program_screen.dart';

class ExpertScreen extends StatefulWidget {
  const ExpertScreen({super.key});

  @override
  State<ExpertScreen> createState() => ExpertScreenState();
}

class ExpertScreenState extends State<ExpertScreen> {
  bool _showPrograms = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProgramController, PurchaseController>(
      builder: (context, programController, purchaseController, child) {
        final state = programController.state;

        final specialists = <int, ProgramSpecialistSummary>{};

        for (final program in state.browsePrograms) {
          final specialist = program.specialist;

          if (specialist != null) {
            specialists.putIfAbsent(specialist.id, () => specialist);
          }
        }

        return BlurryModalProgressHUD(
          inAsyncCall: state.isLoading,
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
                _buildMyProgramCard(purchaseController.state.enrollments),

                Text4(_showPrograms ? "Programs" : "Find a Specialist"),
                SizedBox(height: 5),
                Text2(
                  _showPrograms
                      ? "Structured programs run by our specialists."
                      : "Connect with top-rated medical experts for personalized care.",
                ),

                SizedBox(height: 16),

                _buildToggle(),

                SizedBox(height: 20),

                if (_showPrograms)
                  _buildProgramsList(state)
                else
                  _buildSpecialistsList(state, specialists),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Surfaces the client's own purchased program and assigned specialist
  /// (if any) at the top of this tab — previously only ever visible for a
  /// moment right after checkout, with no way back to it afterwards.
  Widget _buildMyProgramCard(List<EnrollmentModel> enrollments) {
    if (enrollments.isEmpty) return const SizedBox.shrink();

    final enrollment = enrollments.first;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MyProgramScreen()),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryBtn,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MY PROGRAM",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      enrollment.program?.title ?? "Program",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      enrollment.specialist != null
                          ? "Specialist: ${enrollment.specialist!.name}"
                          : enrollment.assignmentStatus.label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(child: _toggleSegment("Specialists", !_showPrograms)),
          Expanded(child: _toggleSegment("Programs", _showPrograms)),
        ],
      ),
    );
  }

  Widget _toggleSegment(String label, bool selected) {
    return GestureDetector(
      onTap: () => setState(() => _showPrograms = label == "Programs"),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBtn : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.bodyText,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialistsList(
    ProgramState state,
    Map<int, ProgramSpecialistSummary> specialists,
  ) {
    if (state.errorMessage != null && specialists.isEmpty) {
      return Text2(state.errorMessage!);
    }

    if (specialists.isEmpty && !state.isLoading) {
      return Text2("No specialists available yet.");
    }

    return Column(
      children: specialists.values.map((specialist) {
        return ExpertProfileCard(
          name: specialist.name,
          specialization: specialist.tier ?? "Specialist",
          imageUrl: specialist.photo ??
              "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=200",
          rating: specialist.rating ?? 0,
          reviewCount: 0,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExpertDetailScreen(
                  specialistId: specialist.id,
                  name: specialist.name,
                  specialization: specialist.tier ?? "Specialist",
                  imageUrl: specialist.photo,
                  rating: specialist.rating ?? 0,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildProgramsList(ProgramState state) {
    if (state.errorMessage != null && state.browsePrograms.isEmpty) {
      return Text2(state.errorMessage!);
    }

    if (state.browsePrograms.isEmpty && !state.isLoading) {
      return Text2("No programs available yet.");
    }

    return Column(
      children: state.browsePrograms
          .map(
            (program) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProgramCard(
                program: program,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProgramCheckoutScreen(program: program),
                    ),
                  );
                },
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgramController>().loadAllPrograms();
      context.read<PurchaseController>().loadMyEnrollments();
    });
  }
}
