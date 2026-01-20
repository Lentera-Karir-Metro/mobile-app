import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/adaptive_image.dart';

/// Card untuk menampilkan progress belajar user dengan thumbnail, title, dan progress bar
/// Design sesuai progress_card.svg: 349x151px dengan background #F5F5F5
class ProgressCard extends StatelessWidget {
  final String? thumbnailPath;
  final String title;
  final String subtitle;
  final int progressPercent;
  final VoidCallback onTap;

  const ProgressCard({
    super.key,
    this.thumbnailPath,
    required this.title,
    required this.subtitle,
    required this.progressPercent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5), // Background #F5F5F5 dari design
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail: 125x74px dengan radius 20px
            AdaptiveImage(
              imagePath: thumbnailPath,
              fallbackAsset: FallbackAssets.sampleImage,
              width: 125,
              height: 74,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(20),
            ),
            const SizedBox(width: 15),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Progress Bar Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: 8,
                          child: LinearProgressIndicator(
                            value: progressPercent / 100,
                            backgroundColor: const Color(0xFFD1D9E8), // #D1D9E8 dari design
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryPurple, // #661FFF
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      
                      // Subtitle dan Percent
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subtitle,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary, // #747474
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '$progressPercent%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primaryPurple, // #661FFF
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
