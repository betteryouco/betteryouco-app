import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/assessment_model.dart';

class AssessmentCard extends StatelessWidget {
  final AssessmentModel assessment;

  const AssessmentCard({super.key, required this.assessment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assessment.title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 2),

          Text(
            assessment.score.toString(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: assessment.scoreColor,
            ),
          ),

          SizedBox(height: 5),

          Row(
            children: [
              if (assessment.showTrendIcon) ...[
                Icon(
                  assessment.change < 0
                      ? Icons.arrow_downward
                      : assessment.change > 0
                      ? Icons.arrow_upward
                      : Icons.remove,
                  size: 16,
                  color: assessment.changeColor,
                ),
                const SizedBox(width: 4),
              ],

              Expanded(
                child: Text(
                  assessment.baselineText,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: assessment.showTrendIcon
                        ? assessment.changeColor
                        : Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
