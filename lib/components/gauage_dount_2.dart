import 'package:betteryou_co/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

Widget stressGauge2(int score, String text) {
  return SizedBox(
    width: 186.w,
    height: 186.w,
    child: SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showTicks: false,
          showLabels: false,
          startAngle: 270,
          endAngle: 270,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.25,
            thicknessUnit: GaugeSizeUnit.factor,
            color: Color(0xFFDCE6BF),
          ),
          pointers: [
            RangePointer(
              value: score.toDouble(),
              width: 0.25,
              sizeUnit: GaugeSizeUnit.factor,
              color: AppColors.tags8,
              cornerStyle: CornerStyle.bothFlat,
            ),
          ],
          annotations: [
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.05,
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "$score %",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    text,
                    style: TextStyle(fontSize: 15.sp, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
