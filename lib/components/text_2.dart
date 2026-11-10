import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget Text2(String text, {TextAlign textAlign = TextAlign.left}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14.sp,
      height: 1.43,
      color: const Color(0xFF685355),
    ),
  );
}
