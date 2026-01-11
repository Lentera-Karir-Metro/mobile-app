import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/home/progress_card.dart';
import 'package:lentera_karir/widgets/universal/inputs/search_bar.dart';

class QuickKelasScreen extends StatefulWidget {
  const QuickKelasScreen({super.key});

  @override
  State<QuickKelasScreen> createState() => _QuickKelasScreenState();
}

class _QuickKelasScreenState extends State<QuickKelasScreen> {
  String selectedMenu = 'Semua Kelas';
  String selectedFilter = 'Semua Kelas';

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
    return Scaffold(
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
    if (selectedFilter == 'Semua Kelas') {
      return _buildAllClasses();
    } else if (selectedFilter == 'On Progress') {
      return _buildProgressClasses();
    } else if (selectedFilter == 'Selesai') {
      return _buildCompletedClasses();
    }
    return const SizedBox.shrink();
  }

  // All Classes - ProgressCard with "Lihat selengkapnya"
  Widget _buildAllClasses() {
    return Column(
      children: [
        ProgressCard(
          thumbnailPath: 'assets/hardcode/sample_image.png',
          title: 'Kursus Flutter Development',
          subtitle: 'Lihat selengkapnya',
          progressPercent: 30,
          onTap: () {
            context.push('/kelas/mulai/1');
          },
        ),
        const SizedBox(height: 16),
        ProgressCard(
          thumbnailPath: 'assets/hardcode/sample_image.png',
          title: 'Kursus UI/UX Design',
          subtitle: 'Lihat selengkapnya',
          progressPercent: 0,
          onTap: () {
            context.push('/kelas/mulai/2');
          },
        ),
        const SizedBox(height: 16),
        ProgressCard(
          thumbnailPath: 'assets/hardcode/sample_image.png',
          title: 'Kursus Backend Development',
          subtitle: 'Lihat selengkapnya',
          progressPercent: 16,
          onTap: () {
            context.push('/kelas/mulai/3');
          },
        ),
        const SizedBox(height: 16),
        ProgressCard(
          thumbnailPath: 'assets/hardcode/sample_image.png',
          title: 'Kursus Data Science',
          subtitle: 'Lihat selengkapnya',
          progressPercent: 100,
          onTap: () {
            context.push('/kelas/mulai/4');
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // On Progress Classes - ProgressCard with "Lihat selengkapnya"
  Widget _buildProgressClasses() {
    return Column(
      children: [
        ProgressCard(
          thumbnailPath: 'assets/hardcode/sample_image.png',
          title: 'Kursus Flutter Development',
          subtitle: 'Lihat selengkapnya',
          progressPercent: 30,
          onTap: () {
            context.push('/kelas/mulai/1');
          },
        ),
        const SizedBox(height: 16),
        ProgressCard(
          thumbnailPath: 'assets/hardcode/sample_image.png',
          title: 'Kursus UI/UX Design',
          subtitle: 'Lihat selengkapnya',
          progressPercent: 62,
          onTap: () {
            context.push('/kelas/mulai/2');
          },
        ),
        const SizedBox(height: 16),
        ProgressCard(
          thumbnailPath: 'assets/hardcode/sample_image.png',
          title: 'Kursus Backend Development',
          subtitle: 'Lihat selengkapnya',
          progressPercent: 16,
          onTap: () {
            context.push('/kelas/mulai/3');
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Completed Classes - ProgressCard with "Lihat selengkapnya"
  Widget _buildCompletedClasses() {
    return Column(
      children: [
        ProgressCard(
          thumbnailPath: 'assets/hardcode/sample_image.png',
          title: 'Kursus Dasar Programming',
          subtitle: 'Lihat selengkapnya',
          progressPercent: 100,
          onTap: () {
            context.push('/kelas/mulai/5');
          },
        ),
        const SizedBox(height: 16),
        ProgressCard(
          thumbnailPath: 'assets/hardcode/sample_image.png',
          title: 'Kursus Git & GitHub',
          subtitle: 'Lihat selengkapnya',
          progressPercent: 100,
          onTap: () {
            context.push('/kelas/mulai/6');
          },
        ),
        const SizedBox(height: 24),
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
