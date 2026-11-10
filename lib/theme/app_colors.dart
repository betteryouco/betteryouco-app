import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color background = Color(0xFFF7F2EF);

  static const Color blobs1 = Color(0xFFFAEEE5);
  static const Color blobs2 = Color(0xFFF7E8F3);

  static const Color primaryBtn = Color(0xFF527C31);
  static const Color secondaryBtn = Color(0xFFDFDFDF);

  static const Color headingText = Color(0xFF242424);
  static const Color bodyText = Color(0xFF685355);

  static const Color icon1 = Color(0xFF047857);
  static const Color icon2 = Color(0xFF7E22CE);

  static const Color tags1 = Color(0xFF054F31);
  static const Color tags2 = Color(0xFFA6F4C5);
  static const Color tags3 = Color(0xFFECFDF3);
  static const Color tags4 = Color(0xFFFAF5FF);
  static const Color tags5 = Color(0xFFE9D5FF);
  static const Color tags6 = Color(0xFFFEDE82);
  static const Color tags7 = Color(0xFFFFF8E1);
  static const Color tags8 = Color(0xFFFB6E0A);
  static const Color tags9 = Color(0xFF7B513B);
  static const Color tags10 = Color(0xFFD6BFAE);

  static const Color tagsAlt1 = Color(0xFFF5F0EC);

  static const Color outline = Color(0xFFF0EEEA);

  static const Color supportingText1 = Color(0xFF008E7F);
  static const Color supportingText2 = Color(0xFF8D7CBA);
  static const Color supportingText3 = Color(0xFFDF9262);

  static const Color white = Color(0xFFFFFFFF);

  // ---------------------------------------------------------------------
  // DASS-21 ("Kai") palette — sampled directly from the reference Figma
  // export (E:\better\figma_ui_screens\new_dass_21_design) so the flow's
  // visuals match the design pixel-for-pixel rather than reusing the
  // app's generic theme colors.
  // ---------------------------------------------------------------------

  static const Color dassBgTop = Color(0xFFF8F0F0);
  static const Color dassBgBottom = Color(0xFFF8F8F0);

  static const Color dassDark = Color(0xFF24380F);
  static const Color dassPrimary = Color(0xFF2F421A);
  static const Color dassPrimaryLight = Color(0xFF3F5528);
  static const Color dassAccent = Color(0xFF507830);
  static const Color dassBright = Color(0xFF609038);
  static const Color dassLightGreen = Color(0xFF8BBB82);

  static const Color dassGold = Color(0xFFC08A2A);
  static const Color dassTan = Color(0xFFF6E7D2);
  static const Color dassLockedBg = Color(0xFFF1EDEA);

  static const Color dassFreeBadgeBg = Color(0xFFEDF3E5);
  static const Color dassMauveBadgeBg = Color(0xFFF5E6EE);
  static const Color dassMauveBadgeText = Color(0xFF8D5C7A);

  static const Color dassHeadline = Color(0xFF181818);
  static const Color dassBodyGray = Color(0xFF6B6560);
  static const Color dassCream = Color(0xFFFBF6F3);
  static const Color dassRingPending = Color(0xFFE4DED8);

  static const List<Color> dassSeverityGradient = [
    Color(0xFFE7EFDC),
    Color(0xFFEDEBCF),
    Color(0xFFF0D9B8),
    Color(0xFFF5DFD3),
    Color(0xFFF2D7D3),
  ];
}