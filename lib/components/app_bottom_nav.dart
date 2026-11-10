import 'package:betteryou_co/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 92, bottom: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryBtn,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.18),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: GNav(
          selectedIndex: selectedIndex,
          onTabChange: onTabChange,
          rippleColor: Colors.transparent,
          hoverColor: Colors.transparent,
          gap: 4,
          duration: const Duration(milliseconds: 250),
          color: Colors.white,
          activeColor: AppColors.primaryBtn,
          tabBackgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          tabs: const [
            GButton(
              icon: Icons.home_outlined,
              text: 'Home',
              textStyle: TextStyle(fontSize: 14),
            ),
            GButton(icon: Icons.assignment_outlined, text: 'Assess',
                textStyle: TextStyle(fontSize: 14)),
            GButton(icon: Icons.add_box_outlined, text: 'Experts',
                textStyle: TextStyle(fontSize: 14)),
            GButton(icon: Icons.person_outline, text: 'Profile',
                textStyle: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
