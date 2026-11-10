import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onSkip;

  const ProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(Color(0xff5A8A34)),
            ),
          ),
        ),

        const SizedBox(width: 20),

        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onSkip,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Skip",
              style: TextStyle(
                fontSize: 16.sp,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
