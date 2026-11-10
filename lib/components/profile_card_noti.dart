import 'package:betteryou_co/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCardNotification extends StatelessWidget {
  final String title;
  final String icon;
  final ValueChanged<dynamic>? onTap;
  final ValueNotifier<bool> controller;

  const ProfileCardNotification({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 24.h,
            height: 24.h,
            child: Image.asset(
              icon,
              width: 24,
              height: 24,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.headingText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          AdvancedSwitch(
            controller: controller,
            activeColor: AppColors.primaryBtn,
            width: 50,
            height: 20,
            onChanged: onTap,
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
