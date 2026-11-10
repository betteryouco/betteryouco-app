import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../components/button_1.dart';
import '../../components/form_field_code.dart';
import '../../components/text_2.dart';
import '../../core/auth/controllers/auth_controller.dart';
import 'reset_password_screen.dart';

class ResetOtpScreen extends StatefulWidget {
  final String email;

  const ResetOtpScreen({super.key, required this.email});

  @override
  State<ResetOtpScreen> createState() => _ResetOtpScreenState();
}

class _ResetOtpScreenState extends State<ResetOtpScreen> {
  final TextEditingController otpController = TextEditingController();

  Future<void> _verify() async {
    final authController = context.read<AuthController>();

    final success = await authController.verifyResetOtp(
      email: widget.email,
      otp: otpController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            email: widget.email,
            otp: otpController.text.trim(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<AuthController>().state.errorMessage ??
                'Invalid verification code',
          ),
        ),
      );
    }
  }

  Future<void> _resend() async {
    final authController = context.read<AuthController>();

    await authController.forgotPassword(email: widget.email);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Code resent.')));
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
                          Text1("Enter verification code"),
                          SizedBox(height: 4.h),
                          Text2(
                            "Enter the 6 digit code we have sent to your email",
                          ),
                          SizedBox(height: 24.h),
                          AppTextFormFieldCode(
                            controller: otpController,
                            onComplete: (pin) => _verify(),
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
                            "Verify",
                            _verify,
                            isLoading: authController.state.isLoading,
                          ),
                          SizedBox(height: 40.h),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Didn’t received the code? ",
                                    style: TextStyle(
                                      color: AppColors.bodyText,
                                      fontSize: 14,
                                      height: 1.57,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Resend",
                                    style: TextStyle(
                                      color: AppColors.primaryBtn,
                                      fontSize: 14,
                                      height: 1.57,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _resend,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
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
    otpController.dispose();
    super.dispose();
  }
}
