import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/learn_path/line_card.dart';
import 'package:lentera_karir/providers/learning_path_provider.dart';
import 'package:lentera_karir/data/models/learning_path_model.dart';

class LearnPathDetailScreen extends StatefulWidget {
  final String pathId;

  const LearnPathDetailScreen({
    super.key,
    required this.pathId,
  });

  @override
  State<LearnPathDetailScreen> createState() => _LearnPathDetailScreenState();
}

class _LearnPathDetailScreenState extends State<LearnPathDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Defer data loading until after the first frame to avoid Provider errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    // Use loadLearningPathContent for enrolled users (returns progress data)
    // This includes is_completed status for each course
    await context.read<LearningPathProvider>().loadLearningPathContent(widget.pathId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LearningPathProvider>(
      builder: (context, provider, child) {
        final learningPath = provider.currentLearningPath;
        
        if (provider.isLoading && learningPath == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        
        if (learningPath == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Gagal memuat learning path'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

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
                    
                    // Info Card
                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildInfoCard(learningPath),
                      ),
                    ),
                    
                    // Courses section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Transform.translate(
                        offset: const Offset(0, -20),
                        child: _buildCoursesSection(context, learningPath),
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
      },
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

  Widget _buildInfoCard(LearningPathModel learningPath) {
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
              learningPath.level ?? 'Learning Path',
              style: AppTextStyles.body3.copyWith(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Title
          Text(
            learningPath.title,
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            learningPath.description ?? '',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection(BuildContext context, LearningPathModel learningPath) {
    // Convert courses from LearningPathModel to Map format for PathCoursesCard
    final courses = learningPath.courses.map((course) => {
      'id': course.id.toString(),
      'title': course.title,
      'category': course.category ?? 'Course',
      'instructor': course.mentor?.name ?? course.instructor ?? 'Instructor',
      'description': course.description ?? '',
      'imagePath': course.thumbnail ?? course.thumbnailUrl,
      // Use isCompleted from backend (set by getLearningPathContent)
      // Falls back to progress check if isCompleted not available
      'isCompleted': course.isCompleted || (course.progressPercent ?? 0) >= 100,
    }).toList();
    
    // Sort courses: completed courses at top (like web implementation)
    courses.sort((a, b) {
      final aCompleted = a['isCompleted'] as bool;
      final bCompleted = b['isCompleted'] as bool;
      if (aCompleted && !bCompleted) return -1;
      if (!aCompleted && bCompleted) return 1;
      return 0;
    });
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          '${courses.length} KELAS',
          style: AppTextStyles.subtitle2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        // Card berisi semua courses
        PathCoursesCard(
          courses: courses,
          onCourseTap: (courseId) {
            context.push('/kelas/detail/$courseId');
          },
        ),
        
        const SizedBox(height: 40),
      ],
    );
  }
}