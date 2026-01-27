import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/navbottom.dart';
import 'package:lentera_karir/widgets/universal/buttons/quick_button.dart';
import 'package:lentera_karir/widgets/home/progress_card.dart';
import 'package:lentera_karir/widgets/home/course_card.dart';
import 'package:lentera_karir/providers/auth_provider.dart';
import 'package:lentera_karir/providers/dashboard_provider.dart';
import 'package:lentera_karir/screens/error/error_screen.dart';
import 'package:lentera_karir/utils/responsive_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboard();
    });
  }
  
  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                SvgPicture.asset(
                  'assets/profile/popup_logout.svg',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  'Keluar Aplikasi?',
                  style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                // Message
                Text(
                  'Apa kamu yakin ingin keluar\ndari aplikasi ini?',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Buttons
                Row(
                  children: [
                    // Keluar button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          SystemNavigator.pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3B30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Keluar',
                          style: AppTextStyles.body1.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Batal button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE0E0E0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Batal',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dashboardProvider = context.watch<DashboardProvider>();
    final user = authProvider.user;
    final stats = dashboardProvider.stats;

    // Show error screen when there's a network/server error
    if (dashboardProvider.status == DashboardStatus.error) {
      return ErrorScreen.server(
        message: dashboardProvider.errorMessage ?? 'Server sedang mengalami gangguan',
        onRetry: () {
          dashboardProvider.loadDashboard();
        },
      );
    }

    // Show loading indicator when loading data
    if (dashboardProvider.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryPurple,
          ),
        ),
        bottomNavigationBar: const NavBottom(currentIndex: 0),
      );
    }
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitConfirmationDialog();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Builder(
              builder: (context) {
                final hPadding = ResponsiveUtils.getHorizontalPadding(context);
                return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // User Avatar Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.divider,
                      backgroundImage: user?.avatar != null 
                        ? NetworkImage(user!.avatar!)
                        : null,
                      child: user?.avatar == null ? Icon(
                        Icons.person,
                        color: AppColors.textSecondary,
                        size: 24,
                      ) : null,
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
                          user?.name ?? 'User',
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
                padding: EdgeInsets.symmetric(horizontal: hPadding),
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
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: QuickButton(
                        count: '${stats?.totalEbooks ?? 0}',
                        label: 'Ebook',
                        iconPath: 'assets/quick-button/e_book_icon.svg',
                        route: '/quick-ebook',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickButton(
                        count: '${stats?.totalCourses ?? 0}',
                        label: 'Kelas',
                        iconPath: 'assets/quick-button/kelas_icon.svg',
                        route: '/quick-kelas',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickButton(
                        count: '${stats?.totalCertificates ?? 0}',
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
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                child: Text(
                  'Lanjutkan Belajar',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Continue learning dari API atau placeholder
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                child: dashboardProvider.continueLearning.isNotEmpty
                    ? ProgressCard(
                        thumbnailPath: dashboardProvider.continueLearning.first.thumbnail,
                        title: dashboardProvider.continueLearning.first.title,
                        subtitle: 'Lanjutkan Belajar',
                        progressPercent: dashboardProvider.continueLearning.first.progressPercent,
                        onTap: () {
                          // Navigate to course detail page (like web frontend)
                          context.push('/kelas/detail/${dashboardProvider.continueLearning.first.id}');
                        },
                      )
                    : GestureDetector(
                        onTap: () => context.push('/explore'),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primaryPurple.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.school_outlined,
                                  size: 30,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kamu belum memiliki kelas',
                                      style: AppTextStyles.subtitle1.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Cari kelas yang sesuai di halaman Explore',
                                      style: AppTextStyles.body2.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: AppColors.primaryPurple,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              
              const SizedBox(height: 32),
              
              // Rekomendasi Untukmu Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                child: Text(
                  'Rekomendasi Untukmu',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Horizontal scrollable course list dari API atau empty state
              SizedBox(
                height: 170, // Reduced for smaller screens
                child: dashboardProvider.recommendedCourses.isNotEmpty
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: hPadding),
                        itemCount: dashboardProvider.recommendedCourses.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final item = dashboardProvider.recommendedCourses[index];
                          return CourseCard(
                            thumbnailPath: item.thumbnail,
                            title: item.title,
                            courseCount: item.courseCount, // Show course count for learning paths
                            mentorName: item.mentorName,
                            mentorPhoto: item.mentorPhoto,
                            onTap: () {
                              // Navigate to learning path detail (backend returns learning paths)
                              context.push('/learn-path/${item.id}');
                            },
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'Belum ada rekomendasi kelas',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
              ),
              
              const SizedBox(height: 24),
            ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const NavBottom(currentIndex: 0),
      ),
    );
  }
}
