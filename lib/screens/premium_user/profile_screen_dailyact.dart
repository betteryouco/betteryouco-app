import 'package:betteryou_co/screens/premium_user/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/daily_activity_card.dart';
import '../../components/gender_card.dart';
import '../../components/text_1.dart';
import '../../components/text_2.dart';

class DailyActivityContent extends StatelessWidget {
  const DailyActivityContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.h),

          Text1("How active are you daily?"),

          const SizedBox(height: 30),

          DailyActivityCard(
            icon: "assets/images/act_1.png",
            title: "Sedentary",
            subtitle: "Mostly sitting or lying down with little to no exercise",
            selected: controller.dailyActivity == DailyActivity.sedentary,
            onTap: () {
              controller.updateDailyActivity(DailyActivity.sedentary);
            },
          ),
          SizedBox(height: 16.h),

          DailyActivityCard(
            icon: "assets/images/act_2.png",
            title: "Lightly active",
            subtitle: "Light activity or exercise 1-3 days a week",
            selected: controller.dailyActivity == DailyActivity.lightlyActive,
            onTap: () {
              controller.updateDailyActivity(DailyActivity.lightlyActive);
            },
          ),
          SizedBox(height: 16.h),

          DailyActivityCard(
            icon: "assets/images/act_3.png",
            title: "Moderately active",
            subtitle: "Moderate exercise 3-5 days a week",
            selected: controller.dailyActivity == DailyActivity.moderatelyActive,
            onTap: () {
              controller.updateDailyActivity(DailyActivity.moderatelyActive);
            },
          ),
          SizedBox(height: 16.h),

          DailyActivityCard(
            icon: "assets/images/act_4.png",
            title: "Very active",
            subtitle: "Hard exercise 6-7 days a week",
            selected: controller.dailyActivity == DailyActivity.veryActive,
            onTap: () {
              controller.updateDailyActivity(DailyActivity.veryActive);
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
