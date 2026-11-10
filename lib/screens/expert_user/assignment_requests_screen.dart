import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/app_background.dart';
import '../../components/button_1.dart';
import '../../components/button_2.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';
import '../../components/text_4.dart';
import '../../core/assignment/assignment_controller.dart';
import '../../models/assignment_request_model.dart';
import '../../theme/app_colors.dart';

/// Clients matched to this specialist, awaiting accept/decline — with the
/// expected-earnings preview shown before they respond, per the
/// onboarding/payment doc's own example UI.
class AssignmentRequestsScreen extends StatefulWidget {
  const AssignmentRequestsScreen({super.key});

  @override
  State<AssignmentRequestsScreen> createState() => _AssignmentRequestsScreenState();
}

class _AssignmentRequestsScreenState extends State<AssignmentRequestsScreen> {
  final Set<int> _respondingTo = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssignmentController>().loadPending();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentController>(
      builder: (context, controller, child) {
        final requests = controller.state.pendingRequests;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: AppBackground(
            child: RefreshIndicator(
              onRefresh: () => controller.loadPending(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                              child: const Center(child: Icon(Icons.arrow_back, size: 20)),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Text1("Assignment Requests"),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      if (controller.state.isLoading && requests.isEmpty)
                        const Center(child: CircularProgressIndicator())
                      else if (requests.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text2("No new clients waiting on your response right now."),
                        )
                      else
                        ...requests.map(
                          (request) => _requestCard(context, controller, request),
                        ),
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

  Widget _requestCard(
    BuildContext context,
    AssignmentController controller,
    AssignmentRequestModel request,
  ) {
    final isResponding = _respondingTo.contains(request.enrollmentId);

    final duration = request.program.durationWeeksMax != null
        ? "${request.program.durationWeeks}–${request.program.durationWeeksMax} weeks"
        : "${request.program.durationWeeks ?? '—'} weeks";

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text4(request.program.title),
          SizedBox(height: 4.h),
          Text2("Duration: $duration"),
          SizedBox(height: 4.h),
          Text2("Your share: ${request.expertSharePercent}%"),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.tags3,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text2("Expected earnings"),
                Text(
                  "${request.currency ?? ''} ${request.expectedEarnings.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.tags1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Button2(
                  "Decline",
                  isResponding ? () {} : () => _decline(controller, request),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Button1(
                  "Accept",
                  isResponding ? () {} : () => _accept(controller, request),
                  isLoading: isResponding,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _accept(AssignmentController controller, AssignmentRequestModel request) async {
    setState(() => _respondingTo.add(request.enrollmentId));

    final success = await controller.accept(request.enrollmentId);

    if (!mounted) return;
    setState(() => _respondingTo.remove(request.enrollmentId));

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Assignment accepted."), backgroundColor: Colors.green),
      );
    } else if (controller.state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.state.errorMessage!), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _decline(AssignmentController controller, AssignmentRequestModel request) async {
    setState(() => _respondingTo.add(request.enrollmentId));

    final success = await controller.decline(request.enrollmentId);

    if (!mounted) return;
    setState(() => _respondingTo.remove(request.enrollmentId));

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Assignment declined.")),
      );
    } else if (controller.state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(controller.state.errorMessage!), backgroundColor: Colors.red),
      );
    }
  }
}
