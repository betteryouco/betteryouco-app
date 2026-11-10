import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/button_social.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/core/profile/ProfileeController.dart';
import 'package:betteryou_co/screens/guest_user/guest_screen.dart';
import 'package:betteryou_co/screens/premium_user/profile_controller.dart';
import 'package:betteryou_co/screens/premium_user/profile_screen_age.dart';
import 'package:betteryou_co/screens/premium_user/profile_screen_biometric.dart';
import 'package:betteryou_co/screens/premium_user/profile_screen_dailyact.dart';
import 'package:betteryou_co/screens/premium_user/profile_screen_gender.dart';
import 'package:betteryou_co/screens/shared/signup_screen.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button_1.dart';
import '../../components/button_2.dart';
import '../../components/form_field.dart';
import '../../components/form_field_label.dart';
import '../../components/progress_header.dart';
import '../../components/text_2.dart';
import '../../models/profile_model.dart';
import '../../models/profile_request.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late final PageController _pageController;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    loadProfile();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //--------------------------------------------------------
  /// NEXT
  //--------------------------------------------------------

  void _next(ProfileController controller) {
    if (controller.isLastStep) {
      _finishWizard();
      return;
    }

    controller.nextStep();

    _pageController.animateToPage(
      controller.currentStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //--------------------------------------------------------
  /// SKIP
  //--------------------------------------------------------

  void _skip(ProfileController controller) {
    if (controller.isLastStep) {
      _finishWizard();
      return;
    }

    controller.nextStep();

    _pageController.animateToPage(
      controller.currentStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  //--------------------------------------------------------
  /// FINISH
  //--------------------------------------------------------

  Future<void> loadProfile() async {
    final p_controller = context.read<ProfileeController>();
    await p_controller.loadSummary();

    // Falls back to sensible empty-profile defaults if the load failed or
    // the user has no profile yet — ProfileModel.fromJson already bakes
    // those defaults in.
    final profile = p_controller.state.summary ?? ProfileModel.empty();

    final controller = context.read<ProfileController>();
    controller.updateAge(profile.age);
    if (profile.gender != null) controller.updateGender(profile.gender!);
    controller.updateHeightUnit(profile.heightUnit);
    controller.updateWeightUnit(profile.weightUnit);
    controller.updateHeight(profile.height);
    controller.updateWeight(profile.weight);
    if (profile.dailyActivity != null) {
      controller.updateDailyActivity(profile.dailyActivity!);
    }

    if (!mounted) return;

    // Only build the step pages (age wheel, height/weight ruler, ...) once
    // the controller already holds the loaded values — those widgets read
    // their starting position in initState(), so building them before the
    // load resolves would leave them stuck on the generic defaults even
    // after this data arrives.
    setState(() => _isLoadingProfile = false);
  }

  Future<void> _finishWizard() async {
    final controller = context.read<ProfileController>();
    final p_controller = context.read<ProfileeController>();

    final request = CompleteProfileRequest(
      age: controller.age,
      gender: controller.gender?.name,
      height: controller.height,
      heightUnit: controller.heightUnit.name,
      weight: controller.weight,
      weightUnit: controller.weightUnit.name,
      // Not collected anywhere in this 4-step wizard (Age/Gender/
      // Biometrics/Daily Activity) — send null rather than a fake
      // constant; the backend already treats it as optional.
      averageSleep: null,
      dailyActivity: controller.dailyActivity?.name,
    );

    final success = await p_controller.completeProfile(request);

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(p_controller.state.errorMessage ?? "Unable to save your profile. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
      return const Scaffold(
        body: AppBackground(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Consumer2<ProfileController, ProfileeController>(
      builder: (_, controller, profileeController, __) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: AppBackground(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  //--------------------------------------------------
                  /// HEADER
                  //--------------------------------------------------
                  ProgressHeader(
                    currentStep: controller.currentStep,
                    totalSteps: ProfileController.totalSteps,
                    onSkip: () => _skip(controller),
                  ),

                  //--------------------------------------------------
                  /// PAGES
                  //--------------------------------------------------
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        AgeContent(),
                        GenderContent(),
                        BiometricsContent(),
                        DailyActivityContent(),
                      ],
                    ),
                  ),

                  //--------------------------------------------------
                  /// BUTTON
                  //--------------------------------------------------
                  Button1(
                    controller.isLastStep ? "Finish" : "Next",
                    () {
                      _next(controller);
                    },
                    isLoading: controller.isLastStep && profileeController.state.isLoading,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
