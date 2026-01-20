import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/kelas/card_detail_kelas.dart';
import 'package:lentera_karir/widgets/kelas/preview.dart';
import 'package:lentera_karir/providers/course_provider.dart';
import 'package:lentera_karir/providers/catalog_provider.dart';
import 'package:lentera_karir/utils/shared_prefs_utils.dart';
import 'package:lentera_karir/data/models/course_model.dart';

/// Halaman detail kelas sesuai design SVG
class DetailKelasScreen extends StatefulWidget {
  final String courseId;
  final bool isPurchased;

  const DetailKelasScreen({
    super.key,
    required this.courseId,
    this.isPurchased = false,
  });

  @override
  State<DetailKelasScreen> createState() => _DetailKelasScreenState();
}

class _DetailKelasScreenState extends State<DetailKelasScreen> {
  bool _isLoggedIn = false;
  bool _isEnrolled = false;
  bool _checkingEnrollment = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeScreen();
    });
  }

  Future<void> _initializeScreen() async {
    // Check if user is logged in
    final token = await SharedPrefsUtils.getAccessToken();
    _isLoggedIn = token != null && token.isNotEmpty;

    // Always use CatalogProvider for course detail preview (like web frontend)
    // This is the PUBLIC endpoint that doesn't require enrollment
    if (mounted) {
      context.read<CatalogProvider>().loadCourseDetail(widget.courseId);
    }

    // If logged in, check enrollment status separately
    if (_isLoggedIn && mounted) {
      await _checkEnrollment();
    } else {
      setState(() {
        _checkingEnrollment = false;
      });
    }
  }

  Future<void> _checkEnrollment() async {
    try {
      // Load user's enrolled courses to check if this course is enrolled
      final courseProvider = context.read<CourseProvider>();
      await courseProvider.loadMyCourses();
      
      // Check if current courseId is in enrolled courses
      final enrolled = courseProvider.myCourses.any(
        (c) => c.courseId == widget.courseId || c.id == widget.courseId
      );
      
      if (mounted) {
        setState(() {
          _isEnrolled = enrolled;
          _checkingEnrollment = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isEnrolled = false;
          _checkingEnrollment = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always use CatalogProvider for course detail (public catalog, like web)
    return _buildWithCatalogProvider();
  }

  Widget _buildWithCatalogProvider() {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<CatalogProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final course = provider.selectedCourse;
          if (course == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kelas tidak ditemukan',
                    style: AppTextStyles.body1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadCourseDetail(widget.courseId),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          return _buildCourseDetail(course);
        },
      ),
    );
  }

  Widget _buildCourseDetail(CourseModel course) {
    final coursePrice = course.formattedPrice;
    final originalPrice = course.formattedOriginalPrice;
    final hasDiscount = course.hasDiscount;
    final thumbnailPath = course.thumbnailUrl ?? 'assets/hardcode/sample_image.png';
    
    // Calculate video and ebook count from modules
    final videoModules = course.modules.where((m) => m.videoUrl != null && m.videoUrl!.isNotEmpty).length;
    final ebookModules = course.modules.where((m) => m.ebookUrl != null && m.ebookUrl!.isNotEmpty).length;
    final videoCount = videoModules > 0 ? videoModules : (course.videoCount ?? course.totalModules);
    final ebookCount = ebookModules > 0 ? ebookModules : (course.ebookCount ?? 0);
    
    final courseDescription = course.description ?? '';
    final courseTitle = course.title;
    
    // Mentor info from backend
    final mentorName = course.mentor?.name ?? course.instructor ?? 'Mentor';
    final mentorTitle = course.mentor?.jobTitle ?? '';
    final mentorPhoto = course.mentor?.avatarUrl;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
              // Main scrollable content
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header dengan banner
                    _buildHeader(courseTitle, course.createdAt, course.updatedAt),

                    // Course Card
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: CardDetailKelas(
                        thumbnailPath: thumbnailPath,
                        price: coursePrice,
                        originalPrice: hasDiscount ? originalPrice : null,
                        hasDiscount: hasDiscount,
                        lifetimeText: "Lifetime Access",
                        videoText: "$videoCount Video",
                        ebookText: "$ebookCount Ebook (PDF)",
                        certificateText: "Bersertifikat",
                      ),
                    ),

                    // About Section
                    _buildAboutSection(courseDescription),

                    // Mentor Section
                    if (!widget.isPurchased) _buildMentorSection(mentorName, mentorTitle, mentorPhoto),

                    // Space untuk bottom sheet preview
                    const SizedBox(height: 200),
                  ],
                ),
              ),

              // Back Button - Fixed di atas
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomBackButton(
                    backgroundColor: AppColors.cardBackground,
                    iconColor: AppColors.textPrimary,
                  ),
                ),
              ),

              // Preview Widget - Bottom Sheet menggunakan DraggableScrollableSheet
              PreviewWidget(
                price: coursePrice,
                totalVideos: videoCount,
                completedVideos: 0,
                isEnrolled: _isEnrolled,
                isCheckingEnrollment: _checkingEnrollment,
                modules: course.modules, // Pass backend modules
                onBuyTap: () {
                  context.push('/kelas/beli/${widget.courseId}');
                },
                onStartTap: () {
                  context.push('/kelas/mulai/${widget.courseId}');
                },
              ),
        ],
      ),
    );
  }

  /// Header dengan banner image dan info
  Widget _buildHeader(String title, DateTime? createdAt, DateTime? updatedAt) {
    // Use current date as fallback if dates are not available
    final now = DateTime.now();
    final releasedDate = createdAt != null
        ? '${createdAt.day} ${_monthName(createdAt.month)} ${createdAt.year}'
        : '${now.day} ${_monthName(now.month)} ${now.year}';
    final lastUpdated = updatedAt != null
        ? '${updatedAt.day} ${_monthName(updatedAt.month)} ${updatedAt.year}'
        : '${now.day} ${_monthName(now.month)} ${now.year}';

    return SizedBox(
      width: double.infinity,
      height: 220, // Reduced height since title is positioned from top
      child: Stack(
        children: [
          // Background banner image - full cover with rounded corners
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.asset(
                'assets/header-banner/header_banner.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Content - positioned below back button area with small gap
          Positioned(
            left: 20,
            right: 20,
            top: 90, // Position below back button with small gap
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Course Title
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                
                // Released date row (separate line)
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/kelas/globe.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Released date $releasedDate',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                
                // Last updated row (separate line)
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/kelas/last_update.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last updated $lastUpdated',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  /// About Section
  Widget _buildAboutSection(String description) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tentang Kelas",
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description.isNotEmpty ? description : 'Tidak ada deskripsi',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  /// Mentor Section
  Widget _buildMentorSection(String mentorName, String mentorTitle, String? mentorPhoto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mentor",
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: mentorPhoto != null && mentorPhoto.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: mentorPhoto,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => _buildMentorPlaceholder(),
                          errorWidget: (context, url, error) => _buildMentorPlaceholder(),
                          memCacheWidth: 200,
                          memCacheHeight: 200,
                        )
                      : _buildMentorPlaceholder(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mentorName,
                        style: AppTextStyles.subtitle1.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (mentorTitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          mentorTitle,
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.person,
        size: 50,
        color: AppColors.primaryPurple,
      ),
    );
  }
}
