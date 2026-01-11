import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Card untuk menampilkan learning path di list
/// Berdasarkan design: path_card.svg
/// 
/// Struktur:
/// - Image thumbnail di kiri (lebih besar)
/// - Title dan duration/kelas info di kanan
/// - Border radius 12px, shadow, white background
class PathCard extends StatelessWidget {
  final String title;
  final String duration;
  final String courses;
  final String imagePath;
  final VoidCallback? onTap;

  const PathCard({
    super.key,
    required this.title,
    required this.duration,
    required this.courses,
    this.imagePath = 'assets/hardcode/sample_image.png',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            // Thumbnail image - diperbesar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 130,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 130,
                    height: 90,
                    color: AppColors.textSecondary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Title and info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title - diperbesar
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Duration and courses badges
                  Row(
                    children: [
                      // Duration badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryPurple,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          duration,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 10),
                      
                      // Courses badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryPurple,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          courses,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryPurple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
