import 'package:betteryou_co/components/text_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

Widget MeasurementCard(
  String title,
  String subtitle,
  String icon,
  VoidCallback onTap, {
  bool isLoading = false,
}) {
  return Card(
    child: ListTile(
      leading: Text(icon,  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      title: Text4(title),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12),),
      onTap: onTap,
    ),
  );
}
