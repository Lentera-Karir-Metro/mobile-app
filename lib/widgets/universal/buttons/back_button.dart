import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Tombol back konsisten dengan ukuran 40x40px
/// Digunakan di Kelas Detail, Quiz screens, dan screen lain yang memerlukan back button
/// Secara default akan kembali ke screen sebelumnya menggunakan context.pop()
class CustomBackButton extends StatelessWidget {
  /// Callback ketika button ditekan
  /// Jika null, akan otomatis menggunakan context.pop() (kembali ke screen sebelumnya)
  final VoidCallback? onPressed;
  
  /// Warna background button
  /// Default: AppColors.backgroundColor (#F5F5F5)
  final Color? backgroundColor;
  
  /// Warna icon panah
  /// Default: AppColors.textPrimary (#1F1F1F)
  final Color? iconColor;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Jika onPressed null, gunakan context.pop() untuk kembali ke screen sebelumnya
      // Ini akan otomatis handle navigation stack dari GoRouter
      onTap: onPressed ?? () => context.pop(),
      child: Container(
        // Size: AppDimensions.iconExtraLarge (40x40px dari analisis)
        width: AppDimensions.iconExtraLarge,
        height: AppDimensions.iconExtraLarge,
        decoration: BoxDecoration(
          // Background: backgroundColor default (#F5F5F5)
          color: backgroundColor ?? AppColors.backgroundColor,
          // Border radius: AppDimensions.cardRadiusSmall (10px dari analisis)
          borderRadius: BorderRadius.circular(AppDimensions.cardRadiusSmall),
          // Border: 15% opacity black dari analisis
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        // Center icon di dalam container
        child: Center(
          child: SvgPicture.asset(
            'assets/back-button/arrow_back.svg',
            // Icon size: 24px dari analisis
            width: AppDimensions.iconLarge,
            height: AppDimensions.iconLarge,
            // Icon color: textPrimary default (#1F1F1F)
            colorFilter: ColorFilter.mode(
              iconColor ?? AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
