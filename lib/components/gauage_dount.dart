import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

Widget stressGauge(int score) {
  return SizedBox(
    width: 186.w,
    height: 186.w,
    child: SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 42,
          showTicks: false,
          showLabels: false,
          startAngle: 270,
          endAngle: 270,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.18,
            thicknessUnit: GaugeSizeUnit.factor,
            color: Color(0xFFDCE6BF),
          ),
          pointers: [
            RangePointer(
              value: score.toDouble(),
              width: 0.18,
              sizeUnit: GaugeSizeUnit.factor,
              color: const Color(0xFFA4BA69),
              cornerStyle: CornerStyle.bothCurve,
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
                    "$score",
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "out of 42",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
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