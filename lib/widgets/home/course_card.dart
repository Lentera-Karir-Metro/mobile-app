import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/adaptive_image.dart';
import 'package:lentera_karir/utils/responsive_utils.dart';

/// Card untuk menampilkan course dengan thumbnail, title, harga, diskon, dan mentor
class CourseCard extends StatelessWidget {
  final String? thumbnailPath;
  final String title;
  final String? price; // Made nullable for learning path cards
  final String? originalPrice; // Harga asli sebelum diskon
  final String? mentorName;
  final String? mentorPhoto;
  final int? courseCount; // Number of courses in learning path
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    this.thumbnailPath,
    required this.title,
    this.price,
    this.originalPrice,
    this.mentorName,
    this.mentorPhoto,
    this.courseCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount =
        originalPrice != null &&
        originalPrice!.isNotEmpty &&
        originalPrice != price;

    // Responsive sizing
    final cardWidth = ResponsiveUtils.getCourseCardWidth(context);
    final thumbnailWidth = cardWidth - 20; // Account for card margin
    final thumbnailHeight = thumbnailWidth * 0.5; // Keep aspect ratio

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail dengan margin, tanpa gap ke content
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              width: thumbnailWidth,
              height: thumbnailHeight,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AdaptiveImage(
                imagePath: thumbnailPath,
                fallbackAsset: FallbackAssets.sampleImage,
                width: thumbnailWidth,
                height: thumbnailHeight,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            // Content dengan padding horizontal 10px, vertical sesuai space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Title - Always 2 lines with auto-scaling text
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final textPainter = TextPainter(
                          text: TextSpan(
                            text: title,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                          ),
                          maxLines: 2,
                          textDirection: TextDirection.ltr,
                        )..layout(maxWidth: constraints.maxWidth);

                        // Cek apakah text overflow
                        final isOverflowing = textPainter.didExceedMaxLines;

                        return Text(
                          title,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            fontSize: isOverflowing
                                ? 11
                                : 13, // Kecilkan jika overflow
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),

                    const SizedBox(height: 6),

                    // Bottom section: Mentor + Price grouped together
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Mentor info
                        if (mentorName != null && mentorName!.isNotEmpty)
                          Row(
                            children: [
                              if (mentorPhoto != null &&
                                  mentorPhoto!.isNotEmpty)
                                Container(
                                  width: 14,
                                  height: 14,
                                  margin: const EdgeInsets.only(right: 4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: AdaptiveImage(
                                      imagePath: mentorPhoto,
                                      fallbackAsset: FallbackAssets.sampleImage,
                                      width: 14,
                                      height: 14,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  mentorName!,
                                  style: AppTextStyles.body3.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 2),

                        // Show course count if available, otherwise show price
                        if (courseCount != null && courseCount! > 0) ...[
                          // Course count for learning paths
                          Row(
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                size: 14,
                                color: AppColors.primaryPurple,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$courseCount Kursus',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ] else if (price != null && price!.isNotEmpty) ...[
                          // Price section with discount
                          if (hasDiscount) ...[
                            // Original price with strikethrough
                            Text(
                              originalPrice!,
                              style: AppTextStyles.body3.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 9,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: AppColors.textSecondary,
                              ),
                            ),
                          ],
                          // Final price (purple, bold)
                          Text(
                            price!,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
