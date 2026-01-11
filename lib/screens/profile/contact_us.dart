import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// Halaman Contact Us
/// Menampilkan opsi untuk menghubungi via Website, Instagram, dan LinkedIn
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan back button dan title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Row(
                children: [
                  // Back button
                  CustomBackButton(
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  // Title
                  Text(
                    'Contact Us',
                    style: AppTextStyles.heading3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(31, 80, 31, 0),
              child: Column(
                children: [
                  // Title
                  Text(
                    'Get In Touch!',
                    style: AppTextStyles.heading2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    'We are here for you! Just tell us anything',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Website button
                  _buildContactButton(
                    icon: 'assets/profile/web.svg',
                    label: 'Website',
                    onTap: () => _launchUrl('https://metro-software.com/'),
                  ),
                  const SizedBox(height: 16),

                  // Instagram button
                  _buildContactButton(
                    icon: 'assets/profile/instagram.svg',
                    label: 'Instagram',
                    onTap: () => _launchUrl(
                      'https://www.instagram.com/metrosoftware?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // LinkedIn button
                  _buildContactButton(
                    icon: 'assets/profile/linkedin.svg',
                    label: 'LinkedIn',
                    onTap: () => _launchUrl(
                      'https://www.linkedin.com/company/pt-metro-indonesian-software/posts/?feedView=all',
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

  Widget _buildContactButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: const Color(0xFFF9F9F9),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Icon
              SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 16),
              // Label
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
