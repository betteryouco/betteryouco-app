import 'package:betteryou_co/components/text_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class HealthSheetHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const HealthSheetHeader({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 42,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(50),
          ),
        ),

        const SizedBox(height: 20),

        Row(
          children: [


            InkWell(
              onTap: onTap,
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Center(
                  child: Icon(Icons.arrow_back, size: 24),
                ),
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Text1(title)
            ),
          ],
        ),

        const SizedBox(height: 26),
      ],
    );
  }
}