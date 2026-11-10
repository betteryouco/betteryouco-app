import 'package:betteryou_co/screens/premium_user/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/gender_card.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';

class GenderContent extends StatelessWidget {
  const GenderContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.h),

          Text1("What is your gender?"),
          SizedBox(height: 5.h),
          Text2("You can update this anytime."),

          const SizedBox(height: 30),

          GenderCard(
            icon: Icons.male_rounded,
            title: "Male",
            selected: controller.gender == Gender.male,
            onTap: () {
              controller.updateGender(Gender.male);
            },
          ),

          SizedBox(height: 16.h),

          GenderCard(
            icon: Icons.female_rounded,
            title: "Female",
            selected: controller.gender == Gender.female,
            onTap: () {
              controller.updateGender(Gender.female);
            },
          ),

          SizedBox(height: 16.h),

          GenderCard(
            icon: Icons.transgender_rounded,
            title: "Non-binary",
            selected: controller.gender == Gender.nonBinary,
            onTap: () {
              controller.updateGender(Gender.nonBinary);
            },
          ),

          SizedBox(height: 16.h),

          GenderCard(
            icon: Icons.person_outline_rounded,
            title: "Prefer not to say",
            selected: controller.gender == Gender.preferNotToSay,
            onTap: () {
              controller.updateGender(Gender.preferNotToSay);
            },
          ),
        ],
      ),
    );
  }
}
