import 'package:betteryou_co/components/text_2.dart';
import 'package:betteryou_co/components/text_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class FeatureCard2 extends StatelessWidget {
  final String title;
  final String description;
  final String num;

  const FeatureCard2({
    super.key,
    required this.title,
    required this.description,
    required this.num,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(color: AppColors.outline,
              borderRadius: BorderRadius.circular(12.r),),
            child: Center(child: Text4(num)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text4(title, textAlign: TextAlign.left),
                const SizedBox(height: 4),
                Text2(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
