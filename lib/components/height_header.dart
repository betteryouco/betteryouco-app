import 'package:betteryou_co/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'header_btn.dart';

Widget heightHeader() {
  return Row(
    children: [
      const Text(
        "Height",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      ),

      const Spacer(),

      Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryBtn),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [unitButton("Ft/In", true), unitButton("Cm", false)],
        ),
      ),
    ],
  );
}
