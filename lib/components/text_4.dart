import 'package:betteryou_co/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget Text4(String text, {TextAlign textAlign = TextAlign.left}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16.sp,
      height: 1.5,
      color: AppColors.headingText,
    ),
  );
}
