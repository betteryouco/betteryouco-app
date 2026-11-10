import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../components/button_1.dart';
import '../../components/form_field.dart';
import '../../components/form_field_label.dart';
import '../../components/text_2.dart';
import '../../core/auth/controllers/auth_controller.dart';
import 'reset_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final authController = context.read<AuthController>();

    final success = await authController.forgotPassword(
      email: emailController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetOtpScreen(email: emailController.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return BlurryModalProgressHUD(
          inAsyncCall: authController.state.isLoading,
          blurEffectIntensity: 7,
          progressIndicator: SpinKitFadingCircle(
            color: AppColors.primaryBtn,
            size: 90.0.w,
          ),
          dismissible: false,
          opacity: 0.2,
          color: AppColors.blobs1,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: AppBackground(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/logo.png",
                            width: 217.w,
                            height: 57.h,
                          ),
                          SizedBox(height: 40.h),
                          Text1("Forgot password"),
                          SizedBox(height: 4.h),
                          Text2("Enter your email below to get the reset code"),
                          SizedBox(height: 24.h),
                          FormFieldLabel("Email"),
                          SizedBox(height: 4.h),
                          AppTextFormField(
                            errorText: authController.getFieldError('email'),
                            hintText: 'Enter your email',
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Button1(
                            "Submit",
                            _submit,
                            isLoading: authController.state.isLoading,
                          ),
                          SizedBox(height: 16.h),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text2("Back to Login"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
