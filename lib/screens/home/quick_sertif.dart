import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/inputs/search_bar.dart';
import 'package:lentera_karir/widgets/universal/adaptive_image.dart';
import 'package:lentera_karir/providers/certificate_provider.dart';
import 'package:lentera_karir/data/models/certificate_model.dart';

class QuickSertifScreen extends StatefulWidget {
  const QuickSertifScreen({super.key});

  @override
  State<QuickSertifScreen> createState() => _QuickSertifScreenState();
}

class _QuickSertifScreenState extends State<QuickSertifScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CertificateProvider>().loadCertificates();
    });
  }

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
            
            // Certificate Cards from Provider
            Consumer<CertificateProvider>(
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
                            onPressed: () => provider.loadCertificates(),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (provider.certificates.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'Belum ada sertifikat',
                        style: AppTextStyles.body1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: provider.certificates.map((certificate) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildCertificateCard(certificate: certificate),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCertificateCard({required CertificateModel certificate}) {
    return GestureDetector(
      onTap: () async {
        // Open certificate PDF directly in browser/PDF reader
        if (certificate.certificateUrl != null && certificate.certificateUrl!.isNotEmpty) {
          final uri = Uri.parse(certificate.certificateUrl!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tidak dapat membuka file')),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sertifikat belum tersedia')),
          );
        }
      },
      child: Container(
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
              // Certificate Image (16:9 ratio)
              AdaptiveImage(
                imagePath: certificate.imageUrl,
                fallbackAsset: FallbackAssets.certificateImage,
                width: 120,
                height: 67.5, // 120 * 9/16 = 67.5 for 16:9 ratio
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(12),
              ),
              
              const SizedBox(width: 16),
            
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      certificate.courseName,
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // View Certificate Link
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
      ),
    );
  }
}
