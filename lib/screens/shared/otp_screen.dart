import 'dart:async';

import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/button_social.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/core/auth/controllers/auth_controller.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../components/button_1.dart';
import '../../components/form_field.dart';
import '../../components/form_field_code.dart';
import '../../components/form_field_label.dart';
import '../../components/snackbar.dart';
import '../../components/text_2.dart';
import '../premium_user/home_screen.dart';
import 'login_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  // The server enforces a 60 second gap between codes; mirror it here so the
  // link is disabled instead of showing an error.
  static const int _cooldownSeconds = 60;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return Scaffold(
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
                          onComplete: (pin) => _verifyOtp(),
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
                          _verifyOtp,
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
                                  text: _secondsLeft > 0
                                      ? "Resend in ${_secondsLeft}s"
                                      : "Resend",
                                  style: TextStyle(
                                    color: _secondsLeft > 0
                                        ? AppColors.bodyText
                                        : AppColors.primaryBtn,
                                    fontSize: 14,
                                    height: 1.57,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _secondsLeft > 0 || authController.state.isLoading
                                        ? null
                                        : _resendOtp,
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
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // A code was just emailed (signup, or a login that required one).
    _secondsLeft = _cooldownSeconds;
    _runTimer();
  }

  void _startCooldown() {
    setState(() => _secondsLeft = _cooldownSeconds);
    _runTimer();
  }

  void _runTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) t.cancel();
      });
    });
  }

  Future<void> _resendOtp() async {
    final authController = context.read<AuthController>();

    final sent = await authController.resendOtp(email: widget.email);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sent
              ? 'A new code has been sent to your email.'
              : (authController.state.errorMessage ??
                  'Could not resend the code. Please try again.'),
        ),
      ),
    );

    if (sent) _startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final authController = context.read<AuthController>();

    final success = await authController.verifyOtp(
      email: widget.email,
      otp: otpController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${authController.state.errorMessage}")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verification Failed')));
    }
  }
}
