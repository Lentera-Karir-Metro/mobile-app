import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/home/progress_card.dart';
import 'package:lentera_karir/widgets/universal/inputs/search_bar.dart';
import 'package:lentera_karir/providers/course_provider.dart';

class QuickKelasScreen extends StatefulWidget {
  const QuickKelasScreen({super.key});

  @override
  State<QuickKelasScreen> createState() => _QuickKelasScreenState();
}

class _QuickKelasScreenState extends State<QuickKelasScreen> {
  String selectedMenu = 'Semua Kelas';
  String selectedFilter = 'Semua Kelas';

  @override
  void initState() {
    super.initState();
    // Load my courses when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadMyCourses();
    });
  }

  @override
/*************  ✨ Windsurf Command ⭐  *************/
/// Build method for QuickKelasScreen widget.
///
/// This method returns a Scaffold widget with a SafeArea widget as its body.
/// The SafeArea widget contains a Column widget with several children:
/// - A SizedBox widget with a height of 16.
/// - A Padding widget with a Row widget as its child. The Row widget contains
///   two children: a CustomBackButton widget and a Text widget.
/// - A SizedBox widget with a height of 24.
/// - A Padding widget with a Column widget as its child. The Column widget contains
///   two children: a Text widget and another Text widget.
/// - A SizedBox widget with a height of 24.
/// - An Expanded widget with a _buildContentSection method as its child.
/// *****  cccf473c-fd07-4b14-995a-04e37095463b  ******
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              
              // Header with Back Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 31),
                child: Row(
                  children: [
                    CustomBackButton(
                      onPressed: () => context.go('/home'),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ), 
              
              const SizedBox(height: 24),
              
              // Description Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 31),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelas Saya',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kumpulan kelas yang telah kamu ikuti dari Lentera Karir',
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Content Section
              Expanded(
                child: _buildContentSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          CustomSearchBar(
            hintText: 'Cari judul kursus',
            onChanged: (value) {
              // Handle search
            },
          ),
          const SizedBox(height: 16),
          
          // Filter Chips - Make scrollable
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua Kelas'),
                const SizedBox(width: 8),
                _buildFilterChip('On Progress'),
                const SizedBox(width: 8),
                _buildFilterChip('Selesai'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Content based on filter
          _buildFilteredContent(),
        ],
      ),
    );
  }

  Widget _buildFilteredContent() {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (provider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Text(
                    provider.errorMessage!,
                    style: AppTextStyles.body1.copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadMyCourses(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        List<dynamic> courses;
        if (selectedFilter == 'Semua Kelas') {
          courses = provider.myCourses;
        } else if (selectedFilter == 'On Progress') {
          courses = provider.inProgressCourses;
        } else {
          courses = provider.completedCourses;
        }

        if (courses.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                selectedFilter == 'Semua Kelas'
                    ? 'Belum ada kelas yang diikuti'
                    : selectedFilter == 'On Progress'
                        ? 'Tidak ada kelas yang sedang berjalan'
                        : 'Belum ada kelas yang selesai',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        }

        return _buildCourseList(courses);
      },
    );
  }

  Widget _buildCourseList(List<dynamic> courses) {
    return Column(
      children: [
        ...courses.map((course) {
          final progress = course.progressPercent ?? 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ProgressCard(
              thumbnailPath: course.thumbnailUrl ?? 'assets/hardcode/sample_image.png',
              title: course.title ?? 'Untitled Course',
              subtitle: 'Lihat selengkapnya',
              progressPercent: progress,
              onTap: () {
                context.push('/kelas/mulai/${course.id}');
              },
            ),
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
