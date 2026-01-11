import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/inputs/search_bar.dart';

class QuickSertifScreen extends StatelessWidget {
  const QuickSertifScreen({super.key});

  @override
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
                    'Sertifikat Saya',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sertifikat yang kamu dapatkan setelah menyelesaikan kelas',
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 31),
        child: Column(
          children: [
            // Search Bar
            const CustomSearchBar(
              hintText: 'Cari sertifikat',
            ),
            
            const SizedBox(height: 24),
            
            // Certificate Cards
            _buildEbookCard(
              title: 'Sertifikat Orientasi Karier Digital',
            ),
            const SizedBox(height: 16),
            _buildEbookCard(
              title: 'Sertifikat Flutter for beginner',
            ),
            const SizedBox(height: 16),
            _buildEbookCard(
              title: 'Sertifikat Ui/UX Design for beginner',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEbookCard({required String title}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Ebook Image (16:9 ratio)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/hardcode/sertifikat.png',
                width: 120,
                height: 67.5, // 120 * 9/16 = 67.5 for 16:9 ratio
                fit: BoxFit.cover,
              ),
            ),
            
            const SizedBox(width: 16),
          
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Read Now Link
                  Text(
                    'Lihat Sertifikat',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w500,
                    ),
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
