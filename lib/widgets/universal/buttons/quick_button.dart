import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/utils/responsive_utils.dart';

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
    // Responsive sizing
    final buttonHeight = ResponsiveUtils.getQuickButtonHeight(context);
    final isSmall = ResponsiveUtils.isSmallScreen(context);
    final double iconSize = isSmall ? 20.0 : 24.0;
    final double numFontSize = isSmall ? 20.0 : 24.0;
    final double labelFontSize = isSmall ? 10.0 : 12.0;
    final double padding = isSmall ? 8.0 : 12.0;
    
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        height: buttonHeight,
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
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Number
                    Text(
                      count,
                      style: TextStyle(
                        color: AppColors.textOnDark,
                        fontSize: numFontSize,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Label
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColors.textOnDark,
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Icon di pojok kanan atas (absolute position)
              Positioned(
                top: padding,
                right: padding,
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
