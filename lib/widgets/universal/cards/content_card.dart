import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Card putih universal dengan shadow subtle untuk wrapping content
/// Digunakan di Home (stats cards), Explore (course cards), Learning Path, Kelas, Profile (menu items)
/// 
/// Widget ini HANYA untuk styling/layout, data dihandle di screen level atau state management
class ContentCard extends StatelessWidget {
  /// Widget child yang akan dibungkus oleh card
  final Widget child;
  
  /// Padding di dalam card
  /// Default: AppDimensions.cardPadding (16px)
  final EdgeInsets? padding;
  
  /// Callback ketika card ditekan (opsional, card bisa non-interactive)
  final VoidCallback? onTap;
  
  /// Border radius card
  /// Default: AppDimensions.cardRadiusMedium (12px)
  /// Gunakan:
  /// - cardRadiusLarge (15px): Learning Path cards, Kelas video thumbnail
  /// - cardRadiusMedium (12px): Home stats, Profile menu, Quiz cards
  /// - cardRadiusSmall (10px): Small cards, chips
  final double? borderRadius;
  
  /// Background color card
  /// Default: AppColors.cardBackground (#FFFFFF)
  final Color? backgroundColor;

  const ContentCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Jika ada onTap, bungkus dengan InkWell untuk ripple effect
    final cardContent = Container(
      decoration: BoxDecoration(
        // Background: cardBackground default (#FFFFFF)
        color: backgroundColor ?? AppColors.cardBackground,
        // Border radius: cardRadiusMedium (12px) default
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.cardRadiusMedium,
        ),
        // Shadow: 6% opacity black, dari analisis Explore
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppDimensions.cardRadiusMedium,
        ),
        child: Padding(
          // Padding: cardPadding (16px) default
          padding: padding ?? const EdgeInsets.all(AppDimensions.cardPadding),
          child: child,
        ),
      ),
    );

    // Jika ada onTap, bungkus dengan GestureDetector
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }

    // Jika tidak ada onTap, return card biasa
    return cardContent;
  }
}
