import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/inputs/search_bar.dart';
import 'package:lentera_karir/widgets/universal/adaptive_image.dart';
import 'package:lentera_karir/providers/ebook_provider.dart';
import 'package:lentera_karir/data/models/ebook_model.dart';

class QuickEbookScreen extends StatefulWidget {
  const QuickEbookScreen({super.key});

  @override
  State<QuickEbookScreen> createState() => _QuickEbookScreenState();
}

class _QuickEbookScreenState extends State<QuickEbookScreen> {
  
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EbookProvider>().loadMyEbooks();
    });
  }

  @override
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
                  hintText: 'Cari ebook berdasarkan judul kursus',
                ),
                
                const SizedBox(height: 24),
                
                // Ebook List
                Expanded(
                  child: Consumer<EbookProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (provider.errorMessage != null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                provider.errorMessage!,
                                style: AppTextStyles.body1.copyWith(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => provider.loadMyEbooks(),
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (provider.ebooks.isEmpty) {
                        return Center(
                          child: Text(
                            'Belum ada ebook yang diunduh',
                            style: AppTextStyles.body1.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: provider.ebooks.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return _buildEbookCard(provider.ebooks[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEbookCard(EbookModel ebook) {
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
          AdaptiveImage(
            imagePath: ebook.coverUrl,
            fallbackAsset: FallbackAssets.sampleImage,
            width: 70,
            height: 86, // 9:16 ratio disesuaikan dengan card
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(12),
          ),
          
          const SizedBox(width: 16),
          
          // Ebook details - centered vertically
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Course title (if available) - BOLD like quick_kelas and quick_sertif
                if (ebook.courseTitle != null && ebook.courseTitle!.isNotEmpty) ...[
                  Text(
                    ebook.courseTitle!,
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ],
                
                // Ebook Title
                Text(
                  ebook.title,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Read now link - opens PDF directly in browser/PDF reader
                GestureDetector(
                  onTap: () async {
                    if (ebook.fileUrl != null && ebook.fileUrl!.isNotEmpty) {
                      final uri = Uri.parse(ebook.fileUrl!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tidak dapat membuka file')),
                          );
                        }
                      }
                    }
                  },
                  child: Text(
                    'Baca Sekarang',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.bold,
                    ),
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