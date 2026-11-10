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
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final authController = context.read<AuthController>();

    final success = await authController.resetPassword(
      email: widget.email,
      otp: widget.otp,
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully.')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
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
                          Text1("Set new password"),
                          SizedBox(height: 4.h),
                          Text2("Your new password must be different from previously used passwords"),
                          SizedBox(height: 24.h),
                          FormFieldLabel("New Password"),
                          SizedBox(height: 4.h),
                          AppTextFormField(
                            errorText: authController.getFieldError('password'),
                            hintText: 'Enter new password',
                            obscureText: true,
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                          ),
                          SizedBox(height: 16.h),
                          FormFieldLabel("Confirm Password"),
                          SizedBox(height: 4.h),
                          AppTextFormField(
                            errorText: authController.getFieldError(
                              'password_confirmation',
                            ),
                            hintText: 'Rewrite new password',
                            obscureText: true,
                            controller: confirmPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
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
                            "Reset Password",
                            _submit,
                            isLoading: authController.state.isLoading,
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
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
