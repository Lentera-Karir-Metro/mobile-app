import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Card untuk menampilkan course dengan thumbnail, title, dan harga
class CourseCard extends StatelessWidget {
  final String thumbnailPath;
  final String title;
  final String price;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.thumbnailPath,
    required this.title,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 211,
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
              width: 191,
              height: 95,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  thumbnailPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.image,
                        size: 40,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Content dengan padding horizontal 10px, vertical sesuai space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              height: 1.3,
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
                            height: 1.3,
                            fontSize: isOverflowing ? 12 : 14, // Kecilkan jika overflow
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                    
                    const Spacer(),
                    
                    // Price (purple, bold, ukuran lebih kecil) - nempel ke bawah
                    Text(
                      price,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
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
