import 'package:flutter/material.dart';

/// Utility class untuk membuat layout responsive
/// Menyesuaikan ukuran berdasarkan lebar layar device
class ResponsiveUtils {
  /// Screen breakpoints
  static const double smallScreen = 360; // Small phones
  static const double mediumScreen = 400; // Medium phones
  static const double largeScreen = 480; // Large phones/phablets

  /// Get horizontal padding berdasarkan screen width
  /// Default 31px, tapi akan menyesuaikan untuk layar kecil
  static double getHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < smallScreen) return 16; // Very small screens
    if (width < mediumScreen) return 20; // Small screens  
    return 24; // Normal screens (reduced from 31)
  }

  /// Get card width untuk horizontal scroll
  /// Memastikan card tidak overflow
  static double getCourseCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Card should be ~55-60% of screen width
    final cardWidth = width * 0.55;
    // Min 180, max 220
    return cardWidth.clamp(180.0, 220.0);
  }

  /// Get thumbnail width untuk course card
  static double getThumbnailWidth(BuildContext context) {
    return getCourseCardWidth(context) - 20; // Account for card padding
  }

  /// Check if screen is small
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < mediumScreen;
  }

  /// Get scaled font size
  static double getScaledFontSize(BuildContext context, double baseFontSize) {
    final width = MediaQuery.of(context).size.width;
    if (width < smallScreen) return baseFontSize * 0.9;
    if (width < mediumScreen) return baseFontSize * 0.95;
    return baseFontSize;
  }

  /// Get quick button height berdasarkan screen width
  static double getQuickButtonHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < smallScreen) return 65;
    if (width < mediumScreen) return 70;
    return 74;
  }

  /// Get safe area padding yang mempertimbangkan notch dll
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding;
    final horizontalPadding = getHorizontalPadding(context);
    return EdgeInsets.fromLTRB(
      horizontalPadding,
      safePadding.top,
      horizontalPadding,
      safePadding.bottom,
    );
  }
}

/// Extension untuk BuildContext agar mudah diakses
extension ResponsiveContext on BuildContext {
  double get horizontalPadding => ResponsiveUtils.getHorizontalPadding(this);
  double get courseCardWidth => ResponsiveUtils.getCourseCardWidth(this);
  bool get isSmallScreen => ResponsiveUtils.isSmallScreen(this);
}
