import 'package:betteryou_co/components/button_1.dart';
import 'package:betteryou_co/components/text_4.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/metric_input.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';
import '../../theme/app_colors.dart';

class BMICalculatorSheet extends StatefulWidget {
  const BMICalculatorSheet({super.key});

  @override
  State<BMICalculatorSheet> createState() => _BMICalculatorSheetState();
}

class _BMICalculatorSheetState extends State<BMICalculatorSheet> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String heightUnit = 'Ft';
  String weightUnit = 'kg';

  double? bmi;
  String? errorText;

  void calculateBMI() {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    // Reject missing, non-numeric, zero, or negative input instead of
    // silently computing (and displaying) an Infinity/NaN/negative BMI.
    if (height == null || weight == null || height <= 0 || weight <= 0) {
      setState(() {
        bmi = null;
        errorText = "Enter a valid height and weight.";
      });
      return;
    }

    double weightInKg = weight;
    if (weightUnit.toLowerCase() == 'lb' || weightUnit.toLowerCase() == 'lbs') {
      weightInKg = weight * 0.45359237;
    }

    double heightInMeters = height;
    String lowerHeightUnit = heightUnit.toLowerCase();

    if (lowerHeightUnit == 'cm') {
      heightInMeters = height / 100;
    } else if (lowerHeightUnit == 'ft' || lowerHeightUnit == 'feet') {
      heightInMeters = height * 0.3048;
    }

    setState(() {
      bmi = weightInKg / (heightInMeters * heightInMeters);
      errorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30.w,
              height: 5.h,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Center(child: Icon(Icons.close, size: 24)),
                  ),
                ),
                SizedBox(width: 20.w),
                Text1("BMI Calculator"),
              ],
            ),

            SizedBox(height: 24.h),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  MetricInputRow(
                    label: 'Height',
                    hint: heightUnit.toLowerCase() == 'cm' ? 'e.g. 170' : 'e.g. 5.75 (decimal feet)',
                    controller: heightController,
                    selectedUnit: heightUnit,
                    units: const ['Ft', 'Cm'],
                    onUnitChanged: (value) {
                      setState(() => heightUnit = value);
                    },
                  ),

                  Divider(color: Colors.grey.shade300, height: 1),

                  MetricInputRow(
                    label: 'Weight',
                    hint: 'e.g. 75',
                    controller: weightController,
                    selectedUnit: weightUnit,
                    units: const ['kg', 'lb'],
                    onUnitChanged: (value) {
                      setState(() => weightUnit = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Button1("Calculate", calculateBMI),

            if (errorText != null) ...[
              const SizedBox(height: 12),
              Text(errorText!, style: const TextStyle(color: Colors.red, fontSize: 13)),
            ],

            if (bmi != null) ...[
              const SizedBox(height: 16),
              Text(
                "BMI: ${bmi!.toStringAsFixed(1)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
