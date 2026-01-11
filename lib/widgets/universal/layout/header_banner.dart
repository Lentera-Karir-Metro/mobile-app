import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';

/// Header banner dengan pattern overlay (#D9D9D9)
/// Digunakan di Learning Path, Kelas (belum/sudah beli), Quiz, Profile
/// 
/// Fitur:
/// - Pattern background dengan border radius top only
/// - Optional title text (white color)
/// - Optional custom child untuk konten dinamis
/// - Optional back button di kiri atas
class HeaderBanner extends StatelessWidget {
  /// Title text yang muncul di header (opsional)
  /// Text color: textOnDark (#F5F5F5)
  /// Text style: heading3 (24px Bold Montserrat)
  final String? title;
  
  /// Height banner (default: 322px dari analisis)
  /// Default: AppDimensions.headerBannerHeight
  final double? height;
  
  /// Custom content di dalam banner (opsional)
  /// Bisa digunakan untuk konten dinamis seperti avatar, stats, dll
  final Widget? child;
  
  /// Menampilkan back button di kiri atas
  /// Default: false
  final bool showBackButton;
  
  /// Callback saat back button ditekan
  /// Default: context.pop()
  final VoidCallback? onBackPressed;

  const HeaderBanner({
    super.key,
    this.title,
    this.height,
    this.child,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? AppDimensions.headerBannerHeight, // 322px default
      decoration: BoxDecoration(
        // Background: primaryPurple dengan pattern image
        color: AppColors.primaryPurple,
        image: const DecorationImage(
          image: AssetImage('assets/header-banner/header_banner.png'),
          fit: BoxFit.cover,
        ),
        // Border radius: screenRadius (20px) di bottom untuk lengkungan
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Custom child (jika ada)
          if (child != null)
            Positioned.fill(
              child: child!,
            ),
          
          // Title text (jika ada dan child tidak ada)
          if (title != null && child == null)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding,
                ),
                child: Text(
                  title!,
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textOnDark, // White text (#F5F5F5)
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          
          // Back button (opsional)
          if (showBackButton)
            Positioned(
              top: 16,
              left: 16,
              child: CustomBackButton(
                onPressed: onBackPressed,
                // Gunakan background putih agar kontras dengan pattern
                backgroundColor: AppColors.cardBackground,
              ),
            ),
        ],
      ),
    );
  }
}
