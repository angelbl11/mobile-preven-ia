import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDesignSystem {
  // Colors
  static const Color primary = Color(0xFF5C8EDC);
  static const Color secondary = Color(0xFF90CAF9);
  static const Color error = Color(0xFFf44336);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color background = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF545454);
  static const Color border = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFBDBDBD);

  // Typography
  static final TextStyle headline1 = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static final TextStyle headline2 = GoogleFonts.inter(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static final TextStyle headline3 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static final TextStyle headline4 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static final TextStyle subtitle1 = GoogleFonts.inter(
    fontSize: 21,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static final TextStyle subtitle2 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    letterSpacing: -0.5,
  );

  static final TextStyle body1 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static final TextStyle body2 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static final TextStyle body3 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static final TextStyle button1 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primary,
    letterSpacing: -0.5,
  );

  static final TextStyle button2 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: primary,
    letterSpacing: -0.5,
  );

  static final TextStyle caption = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static final TextStyle link1 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primary,
    letterSpacing: -0.5,
    decoration: TextDecoration.underline,
    decorationColor: primary,
  );

  static final TextStyle link2 = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    color: primary,
    letterSpacing: -0.5,
    decoration: TextDecoration.underline,
    decorationColor: primary,
  );

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  // Border Radius
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;

  // Shadows
  static final List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black.withAlpha(26),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black.withAlpha(38),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black.withAlpha(51),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    disabledBackgroundColor: disabled,
    disabledForegroundColor: Colors.white.withAlpha(128),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingMd,
      vertical: spacingSm,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
  );

  static final ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: primary,
    side: const BorderSide(color: primary),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingMd,
      vertical: spacingSm,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMd),
    ),
  );

  // Input Styles
  static final InputDecoration textInputDecoration = InputDecoration(
    filled: true,
    fillColor: background,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: const BorderSide(color: border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: const BorderSide(color: border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: const BorderSide(color: primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMd),
      borderSide: const BorderSide(color: error),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: spacingMd,
      vertical: spacingSm,
    ),
  );
}
