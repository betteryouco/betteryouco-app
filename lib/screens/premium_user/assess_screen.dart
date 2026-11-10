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

import '../../components/multi_instrument_trend_chart.dart';
import '../../core/auth/controllers/auth_controller.dart';
import '../../core/health/controllers/health_controller.dart';
import '../../models/assessment_model.dart';
import '../../models/blood_pressure_request.dart';
import '../../models/instrument_trend_response.dart';
import '../../models/task_model.dart';

class AssessScreen extends StatefulWidget {
  const AssessScreen({super.key});

  @override
  State<AssessScreen> createState() => AssessScreenState();
}

class AssessScreenState extends State<AssessScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentController>(
      builder: (context, assessmentController, child) {
        final trend = assessmentController.state.instrumentTrend;

        // Previously read dashboard.latest, which blends DASS-21/GAD-7/
        // PHQ-8 submissions together (the dashboard endpoint has no
        // per-instrument concept) — a card explicitly labeled "DASS-21
        // Assessment" could end up showing a GAD-7 or PHQ-8 score. Use
        // the DASS-21-specific series instead, now that it exists.
        final latestDass21 = (trend != null && trend.dass21.hasData) ? trend.dass21.points.last : null;

        return BlurryModalProgressHUD(
          inAsyncCall: assessmentController.state.isLoading || assessmentController.state.isLoadingTrend,
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
                Text4("Assessments"),
                SizedBox(height: 5),
                Text2("Track your mental and physical wellbeing"),

                SizedBox(height: 24),
                Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE1F3EF),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text4("DASS-21 Assessment"),
                        Spacer(),
                        Text(
                          latestDass21 != null ? "${latestDass21.score}" : "--",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF008E7F),
                            fontSize: 20.sp,
                          ),
                        ),
                      ],
                    ),

                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                            latestDass21 != null
                                ? (latestDass21.interpretation ?? "Combined score")
                                : "Not taken yet",
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        if (latestDass21 != null)
                          Text(
                            DateFormat('MMM d').format(latestDass21.date),
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              color: Color(0xFF685355),
                              fontSize: 12.sp,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),
                Text4("Assessment Trends"),
                SizedBox(height: 4),
                ChartCard(
                  title: 'DASS-21 · GAD-7 · PHQ-8',

                  onViewAll: () {},

                  child: MultiInstrumentTrendChart(
                    trend: assessmentController.state.instrumentTrend ??
                        InstrumentTrendResponse.empty(),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssessmentController>().loadDashboard();
      context.read<AssessmentController>().loadInstrumentTrend();
    });
  }
}
