import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

Widget Button2(String text, VoidCallback onTap) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.r)),
        color: Color(0xFFD3F4B8)),
    child: Material(
      clipBehavior: Clip.hardEdge,
        color: Color(0xFFD3F4B8),
      borderRadius: BorderRadius.all(Radius.circular(50.r)),
      child: InkWell(
        onTap: onTap,
        highlightColor: AppColors.secondaryBtn,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBtn,
            ),
          ),
        ),
      ),
    ),
  );
}
