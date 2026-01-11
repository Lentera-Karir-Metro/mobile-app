import 'package:flutter/material.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/learn_path/line_card.dart';
import 'package:lentera_karir/screens/kelas/detail_kelas.dart';
import 'package:lentera_karir/screens/learning-path/learn_path_detail_dialogs.dart';

class LearnPathDetailScreen extends StatefulWidget {
  final String pathId;
  final String title;
  final String description;
  final String profileSection;
  final String profileDescription;

  const LearnPathDetailScreen({
    super.key,
    required this.pathId,
    required this.title,
    required this.description,
    required this.profileSection,
    required this.profileDescription,
  });

  @override
  State<LearnPathDetailScreen> createState() => _LearnPathDetailScreenState();
}

class _LearnPathDetailScreenState extends State<LearnPathDetailScreen> {
  bool _isFollowing = false;

  // Sample courses data untuk learning path
  List<Map<String, dynamic>> _getCourses() {
    return [
      {
        'id': '1',
        'title': 'Dasar-Dasar Desain Grafis & Teori Warna',
        'category': 'Design',
        'instructor': 'Ayu Putri',
        'description': 'Mempelajari prinsip dasar komposisi visual, tata letak, penggunaan ruang negatif, dan menciptakan desain yang estetis dan fungsional.',
        'isCompleted': true,
      },
      {
        'id': '2',
        'title': 'Mastering Figma untuk UI/UX Design',
        'category': 'Design',
        'instructor': 'Setyo Ari',
        'description': 'Pelatihan intensif penggunaan Figma mulai dari pembuatan vector, auto-layout, hingga sistem komponen untuk efisiensi desain produk.',
        'isCompleted': false,
      },
      {
        'id': '3',
        'title': 'UX Research: Memahami Kebutuhan Pengguna',
        'category': 'Design',
        'instructor': 'Setyo Ari',
        'description': 'Pelatihan intensif penggunaan Figma mulai dari pembuatan vector, auto-layout, hingga sistem komponen untuk efisiensi desain produk.',
        'isCompleted': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final courses = _getCourses();
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Header
                _buildBannerHeader(context),
                
                // Info Card (tanpa horizontal padding agar sama lebar dengan courses card)
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildInfoCard(),
                  ),
                ),
                
                // Courses section dengan negative margin untuk kompensasi offset
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Transform.translate(
                    offset: const Offset(0, -20),
                    child: _buildCoursesSection(context, courses),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
          
          // Floating Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: const CustomBackButton(
                backgroundColor: Colors.white,
                iconColor: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerHeader(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/learn-path/banner_background_path.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryPurple,
                        AppColors.primaryPurple.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Gradient overlay untuk membuat text lebih terbaca
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Design',
              style: AppTextStyles.body3.copyWith(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Title
          Text(
            widget.title,
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            widget.description,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // CTA Button - Ikuti Path / Berhenti Ikuti
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (_isFollowing) {
                  // Berhenti mengikuti path
                  showUnfollowDialog(context, () {
                    setState(() {
                      _isFollowing = false;
                    });
                  });
                } else {
                  // Ikuti path dan tampilkan success dialog
                  showSuccessFollowDialog(context, () {
                    setState(() {
                      _isFollowing = true;
                    });
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFollowing 
                    ? AppColors.backgroundColor 
                    : AppColors.primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: _isFollowing 
                      ? BorderSide(color: AppColors.primaryPurple, width: 2)
                      : BorderSide.none,
                ),
                elevation: 0,
              ),
              child: Text(
                _isFollowing ? 'Berhenti Ikuti' : 'Ikuti Path',
                style: AppTextStyles.button.copyWith(
                  color: _isFollowing 
                      ? AppColors.primaryPurple 
                      : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection(BuildContext context, List<Map<String, dynamic>> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Text(
              '${courses.length} KELAS',
              style: AppTextStyles.subtitle2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '•',
              style: AppTextStyles.subtitle2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '6 jam',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Satu card besar berisi semua courses
        PathCoursesCard(
          courses: courses,
          onCourseTap: (courseId) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailKelasScreen(
                  courseId: courseId,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 40),
      ],
    );
  }
}