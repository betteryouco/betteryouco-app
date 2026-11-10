import 'package:betteryou_co/components/unit_toggle.dart';
import 'package:betteryou_co/screens/premium_user/profile_controller.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_ruler_picker/simple_ruler_picker.dart';

import '../../components/gender_card.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';

class BiometricsContent extends StatelessWidget {
  const BiometricsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.h),

          Text1("What is your Height & Weight?"),
          SizedBox(height: 20.h),

          Row(
            children: [
              Expanded(child: Text2("Height (cm)")),

              /* Expanded(
                child: UnitToggle(
                  items: ["cm", "ft"],
                  selectedIndex: controller.heightUnit.index,
                  onChanged: (int index) {
                    final selectedUnit = HeightUnit.values[index];
                    controller.updateHeightUnit(selectedUnit);
                  },
                ),
              ),*/
            ],
          ),
          SizedBox(height: 5),
          SimpleRulerPicker(
            minValue: controller.rulerMinHeight.toInt(),
            maxValue: controller.rulerMaxHeight.toInt(),
            initialValue: controller.rulerCurrentHeight.toInt(),
            onValueChanged: (value) {
              controller.updateHeightFromRuler(value.toDouble());
            },
            scaleLabelSize: 16,
            scaleBottomPadding: 8,
            scaleItemWidth: 12,
            longLineHeight: 30,
            shortLineHeight: 15,
            lineColor: Colors.black,
            selectedColor: AppColors.primaryBtn,
            labelColor: Colors.black,
            lineStroke: 3,
            height: 120,
          ),
          SizedBox(height: 50.h),

          Row(
            children: [
              Expanded(child: Text2("Weight (Kg)")),

              /* Expanded(
                child: UnitToggle(
                  items: ["cm", "ft"],
                  selectedIndex: controller.heightUnit.index,
                  onChanged: (int index) {
                    final selectedUnit = HeightUnit.values[index];
                    controller.updateHeightUnit(selectedUnit);
                  },
                ),
              ),*/
            ],
          ),
          SizedBox(height: 5),
          SimpleRulerPicker(
            minValue: 30,
            maxValue: 200,
            initialValue: controller.weight.toInt(),
            onValueChanged: (value) {
              controller.updateWeight(value.toDouble());
            },
            scaleLabelSize: 16,
            scaleBottomPadding: 8,
            scaleItemWidth: 12,
            longLineHeight: 30,
            shortLineHeight: 15,
            lineColor: Colors.black,
            selectedColor: AppColors.primaryBtn,
            labelColor: Colors.black,
            lineStroke: 3,
            height: 120,
          ),
        ],
      ),
    );
  }
}
