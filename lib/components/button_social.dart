import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

Widget ButtonSocial(String text, VoidCallback onTap) {
  return Container(
    width: 48.w,
    height: 48.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(50.r)),
      color: AppColors.primaryBtn,
    ),
    child: Material(
      clipBehavior: Clip.hardEdge,
      color: AppColors.white,
      borderRadius: BorderRadius.all(Radius.circular(50.r)),
      child: InkWell(
        onTap: onTap,
        highlightColor: AppColors.secondaryBtn,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Image.asset(text, width: 20.w, height: 20.w),
        ),
      ),
    ),
  );
}
