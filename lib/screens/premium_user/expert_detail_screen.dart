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
import '../../core/messaging/conversation_controller.dart';
import '../../core/review/review_controller.dart';
import '../../models/assessment_model.dart';
import '../../models/blood_pressure_request.dart';
import '../../models/chart_point_dass.dart';
import '../../models/review_model.dart';
import '../../models/task_model.dart';
import '../shared/message_thread_screen.dart';

class ExpertDetailScreen extends StatefulWidget {
  final int specialistId;
  final String name;
  final String specialization;
  final String? imageUrl;
  final double rating;

  const ExpertDetailScreen({
    super.key,
    required this.specialistId,
    required this.name,
    required this.specialization,
    this.imageUrl,
    this.rating = 0,
  });

  @override
  State<ExpertDetailScreen> createState() => ExpertDetailScreenState();
}

class ExpertDetailScreenState extends State<ExpertDetailScreen> {
  int _selectedRating = 0;
  final _reviewBodyController = TextEditingController();

  Future<void> _submitReview() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a star rating.")),
      );
      return;
    }

    final success = await context.read<ReviewController>().submitReview(
          specialistId: widget.specialistId,
          rating: _selectedRating,
          body: _reviewBodyController.text.trim(),
        );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Review submitted."
              : context.read<ReviewController>().state.errorMessage ??
                  "Failed to submit review.",
        ),
      ),
    );

    if (success) {
      _reviewBodyController.clear();
      setState(() => _selectedRating = 0);
    }
  }

  Future<void> _openConversation() async {
    final conversationId = await context
        .read<ConversationController>()
        .startClientConversation(widget.specialistId);

    if (!mounted) return;

    if (conversationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open conversation.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessageThreadScreen(
          conversationId: conversationId,
          isSpecialist: false,
          otherPartyName: widget.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentController>(
      builder: (context, assessmentController, child) {
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
          child: Scaffold(
            body: AppBackground(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                              child: Center(child: Icon(Icons.close, size: 24)),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(child: Text1("Doctor Details")),
                        ],
                      ),

                      SizedBox(height: 20),

                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          widget.imageUrl ??
                              "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=200",
                        ),
                      ),
                      SizedBox(height: 6),
                      Text1(widget.name),
                      SizedBox(height: 4),
                      Text2(widget.specialization),

                      SizedBox(height: 10),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.rating.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1.5, // 30px / 20px
                                          color: const Color(0xFF008E7F),
                                        ),
                                      ),
                                      SizedBox(height: 4,),
                                      Text(
                                        "Rating",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5, // 30px / 20px
                                          color: const Color(0xFF685355),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Container(
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Text(
                                        "< 2h",
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1.5, // 30px / 20px
                                          color: const Color(0xFF008E7F),
                                        ),
                                      ),
                                      SizedBox(height: 4,),
                                      Text(
                                        "Response",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5, // 30px / 20px
                                          color: const Color(0xFF685355),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Container(
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Text(
                                        "140",
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1.5, // 30px / 20px
                                          color: const Color(0xFF008E7F),
                                        ),
                                      ),
                                      SizedBox(height: 4,),
                                      Text(
                                        "Clients",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5, // 30px / 20px
                                          color: const Color(0xFF685355),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: Button1("Message", _openConversation)),
                          SizedBox(width: 16),
                          Expanded(child: Button2("Book Session", _openConversation)),
                        ],
                      ),

                      SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text4("Leave a Review"),
                      ),
                      SizedBox(height: 8),
                      _buildReviewForm(),

                      SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text4("Reviews"),
                      ),
                      SizedBox(height: 8),
                      _buildReviewsList(),
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

  Widget _buildReviewForm() {
    return Consumer<ReviewController>(
      builder: (context, reviewController, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starValue = index + 1;

                  return IconButton(
                    onPressed: () =>
                        setState(() => _selectedRating = starValue),
                    icon: Icon(
                      starValue <= _selectedRating
                          ? Icons.star
                          : Icons.star_border,
                      color: const Color(0xffF4B400),
                      size: 28,
                    ),
                  );
                }),
              ),
              AppTextFormField(
                controller: _reviewBodyController,
                hintText: "Share your experience (optional)",
              ),
              const SizedBox(height: 12),
              Button1(
                "Submit Review",
                _submitReview,
                isLoading: reviewController.state.isSubmitting,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewsList() {
    return Consumer<ReviewController>(
      builder: (context, reviewController, child) {
        final reviews = reviewController.state.reviews;

        if (reviewController.state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (reviews.isEmpty) {
          return Text2("No reviews yet.");
        }

        return Column(
          children: reviews.map(_buildReviewTile).toList(),
        );
      },
    );
  }

  Widget _buildReviewTile(ReviewModel review) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text4(review.clientName)),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: const Color(0xffF4B400),
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          if (review.body != null && review.body!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text2(review.body!),
          ],
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewController>().loadReviews(widget.specialistId);
    });
  }

  @override
  void dispose() {
    _reviewBodyController.dispose();
    super.dispose();
  }
}
