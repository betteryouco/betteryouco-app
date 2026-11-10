import 'package:betteryou_co/components/text_2.dart';
import 'package:betteryou_co/components/text_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;
  final IconData icon;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    this.onTap,
    this.icon = Icons.arrow_forward,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text4(
                    title,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 4),
                  Text2(
                    description,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, size: 24,),
          ],
        ),
      ),
    );
  }
}