import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget Text1(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w500,
      height: 1.5, // 30px / 20px
      color: const Color(0xFF1E2C2F),
    ),
  );
}
