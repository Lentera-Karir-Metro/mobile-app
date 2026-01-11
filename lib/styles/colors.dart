import 'package:flutter/material.dart';

class AppColors {
  // PRIMARY COLORS
  static const Color primaryPurple = Color(0xFF661FFF);      // Brand color - button, active states
  static const Color primaryDark = Color(0xFF5A2FD5);        // Darker purple for hover/pressed

  // BACKGROUND COLORS
  static const Color backgroundColor = Color(0xFFF5F5F5);    // Screen background (semua screen)
  static const Color cardBackground = Color(0xFFFFFFFF);     // Card/container putih
  static const Color secondaryBackground = Color(0xFFF3F3F3); // Secondary card background

  // TEXT COLORS
  static const Color textPrimary = Color(0xFF1F1F1F);        // Primary text (dark on light)
  static const Color textSecondary = Color(0xFF747474);      // Secondary text, placeholders
  static const Color textOnDark = Color(0xFFF5F5F5);         // Text on dark background (header)

  // BORDER & DIVIDER
  static const Color border = Color(0x26000000);             // Subtle borders (opacity 0.15 = 15% of 255 ≈ 38 = 0x26)
  static const Color divider = Color(0xFFF9F9F9);            // Menu dividers

  // PATTERN/PLACEHOLDER
  static const Color patternOverlay = Color(0xFFD9D9D9);     // Pattern backgrounds

  // STATUS COLORS
  static const Color successGreen = Color(0xFF4CAF50);       // Success states
  static const Color errorRed = Color(0xFFEF4444);           // Error states
  static const Color warningOrange = Color(0xFFFFC107);      // Warning states

  // UTILITY COLORS
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
}
