import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/navbottom.dart';
import 'package:lentera_karir/widgets/universal/buttons/quick_button.dart';
import 'package:lentera_karir/widgets/home/progress_card.dart';
import 'package:lentera_karir/widgets/home/course_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // User Avatar Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 31),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.divider,
                      child: Icon(
                        Icons.person,
                        color: AppColors.textSecondary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang',
                          style: AppTextStyles.body2.copyWith(
                            color: const Color(0xFFAAA9A9),
                          ),
                        ),
                        Text(
                          'Ridho Dwi Syahputra',
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Search Bar (as button)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 31),
                child: GestureDetector(
                  onTap: () => context.push('/home/search'),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.divider,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Cari judul kursus',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Statistics Cards (Quick Buttons)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 31),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: QuickButton(
                        count: '6',
                        label: 'Ebook',
                        iconPath: 'assets/quick-button/e_book_icon.svg',
                        route: '/quick-ebook',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickButton(
                        count: '12',
                        label: 'Kelas',
                        iconPath: 'assets/quick-button/kelas_icon.svg',
                        route: '/quick-kelas',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickButton(
                        count: '5',
                        label: 'Sertifikat',
                        iconPath: 'assets/quick-button/sertif_icon.svg',
                        route: '/quick-sertif',
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Lanjutkan Belajar Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 31),
                child: Text(
                  'Lanjutkan Belajar',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 31),
                child: ProgressCard(
                  thumbnailPath: 'assets/hardcode/sample_image.png',
                  title: 'Bootcamp: Kick-Start Karier Digital',
                  subtitle: 'Lanjutkan Belajar',
                  progressPercent: 25,
                  onTap: () {
                    // Navigate to mulai kelas (kelas yang sudah dibeli)
                    context.push('/kelas/mulai/1');
                  },
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Rekomendasi Untukmu Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 31),
                child: Text(
                  'Rekomendasi Untukmu',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Horizontal scrollable course list
              SizedBox(
                height: 185,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 31),
                  children: [
                    CourseCard(
                      thumbnailPath: 'assets/hardcode/sample_image.png',
                      title: 'Dasar Desain Grafis & Teori Warna',
                      price: 'Rp200.000',
                      onTap: () {
                        context.push('/kelas/detail/1');
                      },
                    ),
                    const SizedBox(width: 16),
                    CourseCard(
                      thumbnailPath: 'assets/hardcode/sample_image.png',
                      title: 'Teknik Interview untuk Desainer Profesional di Perusahaan Teknologi Besar',
                      price: 'Rp250.000',
                      onTap: () {
                        context.push('/kelas/detail/2');
                      },
                    ),
                    const SizedBox(width: 16),
                    CourseCard(
                      thumbnailPath: 'assets/hardcode/sample_image.png',
                      title: 'Flutter untuk pemula',
                      price: 'Rp300.000',
                      onTap: () {
                        context.push('/kelas/detail/3');
                      },
                    ),
                    const SizedBox(width: 16),
                    CourseCard(
                      thumbnailPath: 'assets/hardcode/sample_image.png',
                      title: 'Mastering User Interface and User Experience Design for Modern Applications',
                      price: 'Rp350.000',
                      onTap: () {
                        context.push('/kelas/detail/4');
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBottom(currentIndex: 0),
    );
  }
}
