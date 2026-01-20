import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/adaptive_image.dart';

class CardDetailKelas extends StatelessWidget {
  final String? thumbnailPath;
  final String price;
  final String? originalPrice; // Original price before discount (optional)
  final bool hasDiscount; // Whether there's a discount
  final String lifetimeText;
  final String videoText;
  final String ebookText;
  final String certificateText;

  const CardDetailKelas({
    super.key,
    this.thumbnailPath,
    required this.price,
    this.originalPrice,
    this.hasDiscount = false,
    required this.lifetimeText,
    required this.videoText,
    required this.ebookText,
    required this.certificateText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail image - diperbesar
          Container(
            margin: const EdgeInsets.fromLTRB(15.5, 15, 15.5, 0),
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: AdaptiveImage(
              imagePath: thumbnailPath,
              fallbackAsset: FallbackAssets.sampleImage,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          
          // Content section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price section with discount
                if (hasDiscount && originalPrice != null) ...[
                  // Original price with strikethrough
                  Text(
                    originalPrice!,
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                // Final price
                Text(
                  price,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: hasDiscount ? const Color(0xFF34C759) : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Info items dengan Material Icons
                _buildInfoItem(
                  icon: Icons.all_inclusive,
                  text: lifetimeText,
                ),
                const SizedBox(height: 8),
                _buildInfoItem(
                  icon: Icons.play_circle_outline,
                  text: videoText,
                ),
                const SizedBox(height: 8),
                _buildInfoItem(
                  icon: Icons.menu_book_outlined,
                  text: ebookText,
                ),
                const SizedBox(height: 8),
                _buildInfoItem(
                  icon: Icons.card_membership_outlined,
                  text: certificateText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primaryPurple,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
