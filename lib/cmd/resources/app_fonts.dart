import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_preven_ia_app/cmd/resources/app_colors.dart';

class AppFonts {
  /// headline1 text style
  static TextStyle headline1 = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle headline2 = GoogleFonts.poppins(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle headline3 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle headline4 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle subtitle1 = GoogleFonts.poppins(
    fontSize: 21,
    fontWeight: FontWeight.w400,
    color: AppColors.text2,
  );

  static TextStyle subtitle2 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF666666),
    letterSpacing: -0.5,
  );

  static TextStyle body1 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.text1,
    letterSpacing: -0.5,
  );

  static TextStyle body2 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle body3 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle button1 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: -0.5,
  );

  static TextStyle button2 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    letterSpacing: -0.5,
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle link1 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    letterSpacing: -0.5,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );

  static TextStyle link2 = GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    color: AppColors.primary,
    letterSpacing: -0.5,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );
}
