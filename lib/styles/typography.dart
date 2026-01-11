import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static const String fontFamily = 'Montserrat';

  // Heading Styles
  static TextStyle heading1 = GoogleFonts.montserrat(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static TextStyle heading2 = GoogleFonts.montserrat(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.3,
  );

  static TextStyle heading3 = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2,
  );

  static TextStyle heading4 = GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.15,
  );

  // Subtitle Styles
  static TextStyle subtitle1 = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static TextStyle subtitle2 = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  // Body Styles
  static TextStyle body1 = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static TextStyle body2 = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static TextStyle body3 = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // Caption Styles
  static TextStyle caption = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
  );

  static TextStyle captionSmall = GoogleFonts.montserrat(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  // Button Styles
  static TextStyle button = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle buttonSmall = GoogleFonts.montserrat(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // Label Style (untuk bottom nav, chips, dll)
  static TextStyle label = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // DEPRECATED - kept for backward compatibility, use 'button' instead
  @Deprecated('Use button instead')
  static TextStyle get buttonText => button;
}
