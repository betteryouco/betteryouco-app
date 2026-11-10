import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/button_social.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/core/auth/controllers/auth_controller.dart';
import 'package:betteryou_co/screens/shared/otp_screen.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../components/button_1.dart';
import '../../components/form_field.dart';
import '../../components/form_field_label.dart';
import '../../components/text_2.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;

  final _storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();
  String? userType;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: AppBackground(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
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
                          /*                        SizedBox(height: 40.h),*/
                          Spacer(),
                          Text1(
                            userType == "client"
                                ? "Patient Signup"
                                : "Expert Signup",
                          ),

                          SizedBox(height: 4.h),
                          Text2("Create an account to continue"),
                          SizedBox(height: 24.h),
                          FormFieldLabel("Name"),
                          SizedBox(height: 4.h),
                          AppTextFormField(
                            errorText: authController.getFieldError('name'),
                            hintText: 'Enter your name',
                            keyboardType: TextInputType.name,
                            controller: nameController,
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                ? 'Please enter your name'
                                : null,
                          ),
                          SizedBox(height: 12.h),
                          FormFieldLabel("Email"),
                          SizedBox(height: 4.h),
                          AppTextFormField(
                            errorText: authController.getFieldError('email'),
                            hintText: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty)
                                return 'Please enter your email';
                              if (!RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              ).hasMatch(value.trim())) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 12.h),
                          FormFieldLabel("Phone"),
                          SizedBox(height: 4.h),
                          AppTextFormField(
                            errorText: authController.getFieldError('phone'),
                            hintText: 'Enter your phone number',
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                          ),
                          SizedBox(height: 12.h),
                          FormFieldLabel("Password"),
                          SizedBox(height: 4.h),
                          AppTextFormField(
                            errorText: authController.getFieldError('password'),
                            hintText: 'Enter your password',
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordController,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Please enter a password';
                              if (value.length < 8)
                                return 'Password must be at least 8 characters';
                              return null;
                            },
                          ),
                          SizedBox(height: 12.h),
                          FormFieldLabel("Confirm Password"),
                          SizedBox(height: 4.h),
                          AppTextFormField(
                            errorText: authController.getFieldError(
                              'password_confirmation',
                            ),
                            hintText: 'Rewrite your password',
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            controller: confirmPasswordController,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Please confirm your password';
                              if (value != passwordController.text)
                                return 'Passwords do not match';
                              return null;
                            },
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
                            "Signup",
                            _register,
                            isLoading: authController.state.isLoading,
                          ),

                          SizedBox(height: 28.h),
                          Image.asset(
                            "assets/images/divider.png",
                            width: 358.w,
                            height: 22.h,
                          ),

                          SizedBox(height: 28.h),
                          if (authController.state.errorMessage != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(1),
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Center(
                                child: Text(
                                  authController.state.errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ],

                          /* Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonSocial("assets/images/ic_fb.png", () {}),
                            SizedBox(width: 12.h),
                            ButtonSocial("assets/images/ic_google.png", () {}),
                          ],
                        ),*/
                          SizedBox(height: 40.h),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Already have an account? ",
                                    style: TextStyle(
                                      color: AppColors.bodyText,
                                      fontSize: 14,
                                      height: 1.57,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                      color: AppColors.primaryBtn,
                                      fontSize: 14,
                                      height: 1.57,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => LoginScreen(),
                                          ),
                                        );
                                      },
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

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authController = context.read<AuthController>();

    final success = await authController.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      role: userType ?? "client",
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP sent successfully')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OtpScreen(email: emailController.text),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    /* nameController.text = "Arslan";
    emailController.text = "arslan.hashmi333@gmail.com";
    passwordController.text = "arslan1122";
    confirmPasswordController.text = "arslan1122";*/

    _loadUserType(); // Call an async helper method
  }

  // Helper method to fetch the value and update state
  Future<void> _loadUserType() async {
    final type = await _storage.read(key: 'user_type');
    setState(() {
      userType = type; // Assuming userType is a variable in your State class
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
