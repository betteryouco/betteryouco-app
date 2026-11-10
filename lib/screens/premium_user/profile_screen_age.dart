import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/screens/premium_user/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/text_2.dart';
import '../../components/text_3.dart';

class AgeContent extends StatefulWidget {
  const AgeContent({super.key});

  @override
  State<AgeContent> createState() => _AgeContentState();
}

class _AgeContentState extends State<AgeContent> {
  late FixedExtentScrollController _wheelController;

  static const int _minAge = 13;
  static const int _maxAge = 100;

  @override
  void initState() {
    super.initState();

    final age = context.read<ProfileController>().age;
    // Clamp defensively — a saved age outside this wheel's 13-100 range
    // (bad data, migration artifact) would otherwise put initialItem out
    // of bounds and break the wheel.
    final clampedAge = age.clamp(_minAge, _maxAge);

    _wheelController = FixedExtentScrollController(initialItem: clampedAge - _minAge);
  }

  @override
  void dispose() {
    _wheelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.h),

          Text1("How old are you?"),
          SizedBox(height: 5.h),
          Text2("You can update this anytime."),

          const SizedBox(height: 30),

          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ListWheelScrollView.useDelegate(
                    controller: _wheelController,
                    physics: const FixedExtentScrollPhysics(),
                    itemExtent: 50,
                    diameterRatio: 2.8,
                    perspective: 0.003,
                    squeeze: 1,
                    onSelectedItemChanged: (index) {
                      controller.updateAge(index + _minAge);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: _maxAge - _minAge + 1,
                      builder: (context, index) {
                        final age = index + _minAge;

                        final selected = age == controller.age;

                        return Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: selected ? 24 : 18,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: selected
                                  ? Colors.transparent
                                  : Colors.grey.shade400,
                            ),
                            child: Text("$age"),
                          ),
                        );
                      },
                    ),
                  ),

                  IgnorePointer(
                    child: Container(
                      width: 86,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(0xff5C8A37),
                          width: 2,
                        ),
                        color: Colors.white.withOpacity(.90),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        controller.age.toString(),
                        style:  TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1E2C2F),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}
