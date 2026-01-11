import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Tombol utama dengan warna brand purple (#661FFF)
/// Digunakan di Auth (login, register, reset password), Kelas, Quiz, dan semua screen dengan action button
class PrimaryButton extends StatelessWidget {
  /// Text yang ditampilkan di dalam button
  final String text;
  
  /// Callback ketika button ditekan
  final VoidCallback? onPressed;
  
  /// Status loading (menampilkan CircularProgressIndicator)
  final bool isLoading;
  
  /// Lebar button (null = auto width mengikuti container)
  final double? width;
  
  /// Tinggi button (default: AppDimensions.buttonHeight = 43px)
  final double? height;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Width: null berarti mengikuti parent, atau custom width
      width: width,
      // Height: menggunakan AppDimensions.buttonHeight (43px) jika tidak ada custom height
      height: height ?? AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          // Background color: primaryPurple (#661FFF) saat aktif
          backgroundColor: AppColors.primaryPurple,
          // Disabled color: abu-abu transparan
          disabledBackgroundColor: AppColors.textSecondary.withValues(alpha: 0.3),
          // Foreground color: textOnDark (#F5F5F5 white) untuk text
          foregroundColor: AppColors.textOnDark,
          // Border radius: buttonRadius (24.5px) untuk rounded button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          // Elevation untuk shadow
          elevation: isLoading || onPressed == null ? 0 : 2,
          shadowColor: AppColors.primaryPurple.withValues(alpha: 0.3),
          // Padding vertikal untuk memastikan text centered
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenPadding,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: AppDimensions.iconMedium,   // 20px
                height: AppDimensions.iconMedium,  // 20px
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.textOnDark,  // White loading indicator
                  ),
                ),
              )
            : Text(
                text,
                // Menggunakan AppTextStyles.button untuk text style
                style: AppTextStyles.button.copyWith(
                  color: AppColors.textOnDark,  // White text
                ),
              ),
      ),
    );
  }
}
