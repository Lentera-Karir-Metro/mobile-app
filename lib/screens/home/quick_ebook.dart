import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/inputs/search_bar.dart';

class QuickEbookScreen extends StatelessWidget {
  const QuickEbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 31, right: 31, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan back button
              Row(
                children: [
                  CustomBackButton(
                    onPressed: () {
                      context.go('/home');
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Title section
              Text(
                'Ebook Saya',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                'Daftar Ebook yang telah diunduh pada setiap kelas',
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Search bar
              const CustomSearchBar(
                hintText: 'Cari judul ebook',
              ),
              
              const SizedBox(height: 24),
              
              // Ebook List
              Expanded(
                child: ListView(
                  children: [
                    _buildEbookCard(
                      'Ebook Orientasi Karier Digital',
                    ),
                    const SizedBox(height: 16),
                    _buildEbookCard(
                      'Ebook Asah Digital Mindset',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEbookCard(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Ebook thumbnail (9:16 ratio)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 70,
              height: 86, // 9:16 ratio disesuaikan dengan card
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Image.asset(
                'assets/hardcode/sample_image.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Ebook details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Read now link
                Text(
                  'Baca Sekarang',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}