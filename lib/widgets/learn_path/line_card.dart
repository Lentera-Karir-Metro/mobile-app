import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Widget untuk menampilkan SATU CARD BESAR berisi semua courses dalam learning path
/// dengan line dan circle indicator di dalamnya
/// Berdasarkan design: line_card.svg
class PathCoursesCard extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  final Function(String courseId) onCourseTap;

  const PathCoursesCard({
    super.key,
    required this.courses,
    required this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          courses.length,
          (index) => _buildCourseItem(
            course: courses[index],
            isFirst: index == 0,
            isLast: index == courses.length - 1,
            onTap: () => onCourseTap(courses[index]['id']),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseItem({
    required Map<String, dynamic> course,
    required bool isFirst,
    required bool isLast,
    required VoidCallback onTap,
  }) {
    final bool isCompleted = course['isCompleted'] ?? false;
    final String circleColor = isCompleted ? '#6C3FD1' : '#747474';
    final String lineColor = '#747474';

    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 0, // No spacing, line will handle connection
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Line and Circle indicator using SVG
            SizedBox(
              width: 32,
              child: Column(
                children: [
                  // Top line (jika bukan first) - menggunakan line.svg
                  if (!isFirst)
                    SvgPicture.string(
                      '<svg width="2" height="25" viewBox="0 0 2 25" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1 25L1 0" stroke="$lineColor" stroke-width="2"/></svg>',
                      width: 2,
                      height: 25,
                    ),
                  
                  // Circle indicator - menggunakan circle.svg dengan warna dinamis
                  SvgPicture.string(
                    '<svg width="32" height="31" viewBox="0 0 32 31" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="32" height="31" rx="15.5" fill="$circleColor"/></svg>',
                    width: 32,
                    height: 31,
                  ),
                  
                  // Bottom line (jika bukan last) - menggunakan Expanded untuk fill space
                  if (!isLast)
                    Expanded(
                      child: SvgPicture.string(
                        '<svg width="2" height="100%" viewBox="0 0 2 160" preserveAspectRatio="none" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M1 160L1 0" stroke="$lineColor" stroke-width="2"/></svg>',
                        width: 2,
                        fit: BoxFit.fill,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Right side: Course content (clickable)
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : 30,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          course['imagePath'] ?? 'assets/hardcode/sample_image.png',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 70,
                              height: 70,
                              color: AppColors.textSecondary.withValues(alpha: 0.1),
                              child: Icon(
                                Icons.image,
                                color: AppColors.textSecondary,
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Course info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              course['title'],
                              style: AppTextStyles.subtitle2.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 6),

                            // Category
                            Text(
                              course['category'],
                              style: AppTextStyles.body3.copyWith(
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Instructor
                            Text(
                              'By: ${course['instructor']}',
                              style: AppTextStyles.body3.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Description
                            Text(
                              course['description'],
                              style: AppTextStyles.body3.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DEPRECATED - Backward compatibility
// Gunakan PathCoursesCard untuk card besar yang berisi semua courses
class LineCard extends StatelessWidget {
  final String courseId;
  final String title;
  final String category;
  final String instructor;
  final String description;
  final String imagePath;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;

  const LineCard({
    super.key,
    required this.courseId,
    required this.title,
    required this.category,
    required this.instructor,
    required this.description,
    this.imagePath = 'assets/hardcode/sample_image.png',
    this.isCompleted = false,
    this.isFirst = false,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // This is now deprecated, use PathCoursesCard instead
    return const SizedBox.shrink();
  }
}
