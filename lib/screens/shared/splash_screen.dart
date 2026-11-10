import 'package:betteryou_co/components/app_background.dart';
import 'package:betteryou_co/components/button_social.dart';
import 'package:betteryou_co/components/text_1.dart';
import 'package:betteryou_co/screens/expert_user/expert_main_screen.dart';
import 'package:betteryou_co/screens/guest_user/guest_screen.dart';
import 'package:betteryou_co/screens/premium_user/home_screen.dart';
import 'package:betteryou_co/screens/shared/login_screen.dart';
import 'package:betteryou_co/screens/shared/welcome_screen.dart';
import 'package:betteryou_co/theme/app_colors.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../components/button_1.dart';
import '../../components/form_field.dart';
import '../../components/form_field_label.dart';
import '../../components/text_2.dart';
import '../../core/auth/controllers/auth_controller.dart';
import '../../core/auth/guest_session_manager.dart';
import '../../core/auth/session_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
                child: Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 300.w,
                    height: 79.h,
                  ),
                ),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();

      //  _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    final authController = context.read<AuthController>();

    final session = SessionManager.instance;

    final token = await session.getToken();

    // -------------------------
    // Logged-in User
    // -------------------------
    if (token != null) {
      final isValid = await authController.validateSession();

      if (!mounted) return;

      if (isValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return;
      }

      // Invalid token
      await session.logout();
    }

    // -------------------------
    // Guest User
    // -------------------------

    await GuestSessionManager.instance.getToken();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GuestScreen()),
    );
  }

  Future<void> _checkLogin() async {
    try {
      final authController = context.read<AuthController>();

      final session = SessionManager.instance;

      final token = await session.getToken();
      final user = await session.getUser();

      if (token == null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WelcomeScreen()),
        );
        return;
      }

      final isValid = await authController.validateSession();

      if (!mounted) return;

      if (isValid) {
        if (user?['role'] == 'client') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => ExpertMainScreen()),
            (route) => false,
          );
        }
      } else {
        await session.logout();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WelcomeScreen()),
        );
      }
    } catch (e) {
      // Never let an unexpected error (network, storage, etc.) leave the
      // splash screen's non-dismissible loading overlay stuck forever —
      // fall back to the welcome/login flow instead.
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WelcomeScreen()),
      );
    }
  }
}
