import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/app_background.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';
import '../../components/text_4.dart';
import '../../core/purchase/purchase_controller.dart';
import '../../models/enrollment_model.dart';
import '../../theme/app_colors.dart';

/// Shows the client's purchased programs and where each stands in the
/// assignment pipeline (Awaiting Expert / Expert Assigned / Active), per
/// the onboarding doc's purchase flow.
class MyProgramScreen extends StatefulWidget {
  const MyProgramScreen({super.key});

  @override
  State<MyProgramScreen> createState() => _MyProgramScreenState();
}

class _MyProgramScreenState extends State<MyProgramScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurchaseController>().loadMyEnrollments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PurchaseController>(
      builder: (context, controller, child) {
        final enrollments = controller.state.enrollments;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: AppBackground(
            child: RefreshIndicator(
              onRefresh: () => controller.loadMyEnrollments(),
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
                          Text1("My Program"),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      if (controller.state.isLoading && enrollments.isEmpty)
                        const Center(child: CircularProgressIndicator())
                      else if (enrollments.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text2("You haven't purchased a program yet."),
                        )
                      else
                        ...enrollments.map(_enrollmentCard),
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

  Widget _enrollmentCard(EnrollmentModel enrollment) {
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
          Text4(enrollment.program?.title ?? "Program"),
          SizedBox(height: 8.h),
          _statusPill(enrollment.assignmentStatus),
          SizedBox(height: 12.h),
          _stepper(enrollment.assignmentStatus),
          if (enrollment.specialist != null) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: AppColors.bodyText),
                SizedBox(width: 6.w),
                Text2("Specialist: ${enrollment.specialist!.name}"),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusPill(AssignmentStatus status) {
    final Color color = switch (status) {
      AssignmentStatus.active => AppColors.icon1,
      AssignmentStatus.completed => AppColors.icon1,
      AssignmentStatus.cancelled => Colors.red,
      _ => AppColors.tags8,
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }

  Widget _stepper(AssignmentStatus status) {
    const steps = [
      AssignmentStatus.paid,
      AssignmentStatus.awaitingExpert,
      AssignmentStatus.expertAssigned,
      AssignmentStatus.active,
    ];

    final currentIndex = steps.indexOf(status);

    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: currentIndex >= i ? AppColors.primaryBtn : AppColors.secondaryBtn,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          if (i != steps.length - 1) SizedBox(width: 4.w),
        ],
      ],
    );
  }
}
