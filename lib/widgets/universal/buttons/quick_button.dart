import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Widget Quick Button untuk menampilkan statistik user (Ebook, Kelas, Sertifikat)
/// dengan gradient purple background dan icon SVG
class QuickButton extends StatelessWidget {
  /// Jumlah item (contoh: "6", "12", "5")
  final String count;
  
  /// Label item (contoh: "Ebook", "Kelas", "Sertifikat")
  final String label;
  
  /// Path asset icon SVG (contoh: "assets/quick-button/e_book_icon.svg")
  final String iconPath;
  
  /// Route tujuan ketika button ditekan
  final String route;

  const QuickButton({
    super.key,
    required this.count,
    required this.label,
    required this.iconPath,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    // Ukuran icon konsisten untuk semua
    const double iconSize = 24.0;
    
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              // Background dengan pattern image
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primaryPurple, // Fallback
                  image: DecorationImage(
                    image: AssetImage('assets/quick-button/quick_button.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              // Number dan Label di kiri bawah
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Number
                    Text(
                      count,
                      style: const TextStyle(
                        color: AppColors.textOnDark,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Label
                    Text(
                      label,
                      style: const TextStyle(
                        color: AppColors.textOnDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Icon di pojok kanan atas (absolute position)
              Positioned(
                top: 12,
                right: 12,
                child: SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: SvgPicture.asset(
                    iconPath,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    placeholderBuilder: (context) => SizedBox(
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
