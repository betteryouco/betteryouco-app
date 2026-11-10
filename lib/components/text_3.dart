import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget Text3(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(fontWeight: FontWeight.bold,
        fontSize: 32.sp,
        height: 1.21,
        color: const Color(0xFF685355)
    ),
  );
}
