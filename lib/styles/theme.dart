import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'dimensions.dart';

class AppTheme {
  // Light Theme (aplikasi hanya light mode berdasarkan analisis UI/UX)
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryPurple,
      brightness: Brightness.light,
      primary: AppColors.primaryPurple,
      secondary: AppColors.primaryDark,
      error: AppColors.errorRed,
      surface: AppColors.cardBackground,
    ),
    
    scaffoldBackgroundColor: AppColors.backgroundColor,
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.heading2.copyWith(
        color: AppColors.textPrimary,
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: BorderSide(
          color: AppColors.border,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: BorderSide(
          color: AppColors.border,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: const BorderSide(
          color: AppColors.primaryPurple,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: const BorderSide(
          color: AppColors.errorRed,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
        borderSide: const BorderSide(
          color: AppColors.errorRed,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
        vertical: 14,
      ),
      hintStyle: AppTextStyles.body2.copyWith(
        color: AppColors.textSecondary,
      ),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: AppColors.white,
        minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
        ),
        elevation: 0,
        textStyle: AppTextStyles.button,
      ),
    ),
    
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: BorderSide(
          color: AppColors.border,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
        ),
        minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
        textStyle: AppTextStyles.button,
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryPurple,
        textStyle: AppTextStyles.button,
      ),
    ),
    
    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryPurple;
        }
        return Colors.transparent;
      }),
      side: BorderSide(
        color: AppColors.border,
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadiusLarge),
      ),
      margin: EdgeInsets.zero,
    ),
    
    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1.copyWith(
        color: AppColors.textPrimary,
      ),
      displayMedium: AppTextStyles.heading2.copyWith(
        color: AppColors.textPrimary,
      ),
      displaySmall: AppTextStyles.heading3.copyWith(
        color: AppColors.textPrimary,
      ),
      headlineSmall: AppTextStyles.subtitle1.copyWith(
        color: AppColors.textPrimary,
      ),
      titleMedium: AppTextStyles.subtitle2.copyWith(
        color: AppColors.textPrimary,
      ),
      bodyLarge: AppTextStyles.body1.copyWith(
        color: AppColors.textPrimary,
      ),
      bodyMedium: AppTextStyles.body2.copyWith(
        color: AppColors.textSecondary,
      ),
      bodySmall: AppTextStyles.body3.copyWith(
        color: AppColors.textSecondary,
      ),
      labelLarge: AppTextStyles.button.copyWith(
        color: AppColors.textPrimary,
      ),
      labelMedium: AppTextStyles.label.copyWith(
        color: AppColors.textSecondary,
      ),
      labelSmall: AppTextStyles.caption.copyWith(
        color: AppColors.textSecondary,
      ),
    ),
  );
}
