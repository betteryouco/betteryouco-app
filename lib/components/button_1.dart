import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

Widget Button1(String text, VoidCallback onTap,{
  bool isLoading = false}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.r)),
        color: AppColors.primaryBtn),
    child: Material(
      clipBehavior: Clip.hardEdge,
      color: AppColors.primaryBtn,
      borderRadius: BorderRadius.all(Radius.circular(50.r)),
      child: InkWell(
        // Disabled (not just visually swapped for a spinner) while loading,
        // so a fast double-tap can't fire the handler twice before the
        // spinner even paints — was letting purchase/signup/health-log
        // taps fire duplicate requests.
        onTap: isLoading ? null : onTap,
        highlightColor: AppColors.secondaryBtn,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child:  isLoading
              ? SizedBox(
            width: 20.w,
            height: 20.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.white,
            ),
          )
              : Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    ),
  );
}
