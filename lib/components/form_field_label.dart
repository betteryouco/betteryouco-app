import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget FormFieldLabel(String text) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12.sp,
      height: 1.5,
      color: const Color(0xFF685355),
    ),
  );
}
