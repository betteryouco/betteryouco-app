import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/button_social.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/screens/expert_user/expert_main_screen.dart';
import 'package:betteryou_co/screens/guest_user/guest_screen.dart';
import 'package:betteryou_co/screens/premium_user/home_screen.dart';
import 'package:betteryou_co/screens/premium_user/profile_screen.dart';
import 'package:betteryou_co/screens/shared/forgot_password_screen.dart';
import 'package:betteryou_co/screens/shared/otp_screen.dart';
import 'package:betteryou_co/screens/shared/signup_screen.dart';
import 'package:betteryou_co/screens/shared/welcome_screen.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../components/button_1.dart';
import '../../components/button_2.dart';
import '../../components/form_field.dart';
import '../../components/form_field_label.dart';
import '../../components/text_2.dart';
import '../../core/auth/controllers/auth_controller.dart';
import '../../core/auth/guest_session_manager.dart';
import '../../core/auth/session_manager.dart';
import '../../core/guest/guest_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  String? userType;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthController, GuestController>(
      builder: (context, authController, guestController, child) {
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
                          Text1(userType == "client" ? "Patient Login" : "Expert Login"),
                          SizedBox(height: 4.h),
                          Text2("Login to your account"),
                          SizedBox(height: 24.h),
                          FormFieldLabel("Email"),
                          SizedBox(height: 4.h),
                          AppTextFormField(
                            errorText: authController.getFieldError('email'),
                            hintText: 'Enter your email',
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 16.h),
                          FormFieldLabel("Password"),
                          SizedBox(height: 4.h),
                          AppTextFormField(
                            errorText: authController.getFieldError('password'),
                            hintText: 'Enter your password',
                            obscureText: true,
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                          ),
                          SizedBox(height: 8.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: AppColors.primaryBtn,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
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
                            "Login",
                            () {
                              _login();
                            },
                            isLoading: authController.state.isLoading,
                          ),
                          SizedBox(height: 8.h),
                          Image.asset(
                            "assets/images/divider.png",
                            width: 358.w,
                            height: 22.h,
                          ),

                          SizedBox(height: 28.h),
                          if (userType == "client")
                            Button2("Continue as Guest", () {
                              continueAsGuest();
                            }),
                          /*
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonSocial("assets/images/ic_fb.png", () {}),
                              SizedBox(width: 12.h),
                              ButtonSocial(
                                "assets/images/ic_google.png",
                                () async {
                                  final ok = await context
                                      .read<AuthController>()
                                      .loginWithGoogle();

                                  if (ok && context.mounted) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      "/home",
                                    );
                                  }
                                },
                              ),
                            ],
                          ),*/
                          SizedBox(height: 40.h),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Don’t have account? ",
                                    style: TextStyle(
                                      color: AppColors.bodyText,
                                      fontSize: 14,
                                      height: 1.57,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Signup",
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
                                            builder: (_) => SignupScreen(),
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

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final authController = context.read<AuthController>();
    final success = await authController.login(
      email: emailController.text.trim(),
      password: passwordController.text,
      role: userType ?? "client",
    );

    if (!mounted) return;

    final session = SessionManager.instance;
    final token = await session.getToken();
    final user = await session.getUser();

    if (success) {
      if (user?['role'] == 'client') {
        if (user?['profile_complete'] != true) {
          // pushAndRemoveUntil (not pushReplacement) — this only swaps the
          // current route, leaving WelcomeScreen/LoginScreen buried in the
          // back stack, which is what let the back button return to the
          // Welcome screen after a successful login.
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => ProfileScreen()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
            (route) => false,
          );
        }
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ExpertMainScreen()),
          (route) => false,
        );
      }
    } else if ((authController.state.errorMessage ?? '').contains(
      'Email is not verified',
    )) {
      // Right password, but the signup code was never entered. Send a fresh
      // code and open the code screen instead of leaving the user stuck.
      final email = emailController.text.trim();
      await authController.resendOtp(email: email);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OtpScreen(email: email)),
      );
    }
  }

  Future<void> continueAsGuest() async {
    try {
      await GuestSessionManager.instance.initialize();

      if (!context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GuestScreen()),
      );
    } catch (e) {
      debugPrint(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to start guest session.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserType(); // Call an async helper method
  }

  // Helper method to fetch the value and update state
  Future<void> _loadUserType() async {
    final type = await _storage.read(key: 'user_type');
    setState(() {
      userType = type; // Assuming userType is a variable in your State class
    });
  }
}
