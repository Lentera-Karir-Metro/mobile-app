import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';

/// Halaman Beli Kelas - menampilkan detail pembayaran sebelum membeli kelas
class BeliKelasScreen extends StatelessWidget {
  final String courseId;

  const BeliKelasScreen({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace dengan data dari API berdasarkan courseId
    final String courseTitle = "Bootcamp: Kick-start\nKarier Digital";
    final String thumbnailPath = "assets/hardcode/sample_image.png";
    final String price = "Rp250.000";
    final String discount = "Rp0";
    final String totalPrice = "Rp250.000";
    final int videoCount = 15;
    final int ebookCount = 2;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                _buildHeader(courseTitle),

                // Course Card dengan thumbnail
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: _buildCourseCard(
                    thumbnailPath: thumbnailPath,
                    price: price,
                    videoCount: videoCount,
                    ebookCount: ebookCount,
                  ),
                ),

                // Tentang Kursus Section
                _buildAboutSection(),

                // Payment Details Section
                _buildPaymentSection(
                  price: price,
                  discount: discount,
                  totalPrice: totalPrice,
                ),

                // Space untuk button
                const SizedBox(height: 100),
              ],
            ),
          ),

          // Back Button - Fixed di atas
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CustomBackButton(
                backgroundColor: AppColors.cardBackground,
                iconColor: AppColors.textPrimary,
              ),
            ),
          ),

          // Bottom Button - Fixed di bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomButton(context, courseId),
          ),
        ],
      ),
    );
  }

  /// Header dengan banner image dan title
  Widget _buildHeader(String title) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Stack(
        children: [
          // Background banner image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.asset(
                'assets/header-banner/header_banner.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content di bagian bawah banner
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Course Title
                Text(
                  title,
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),

                // Released date row
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/kelas/globe.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Released date March 2025',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Last updated row
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/kelas/last_update.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last updated August 2025',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Course Card dengan thumbnail dan info
  Widget _buildCourseCard({
    required String thumbnailPath,
    required String price,
    required int videoCount,
    required int ebookCount,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                thumbnailPath,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price
                Text(
                  price,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                // Info items
                _buildInfoItem(
                  icon: Icons.all_inclusive,
                  text: 'Lifetime Access',
                  color: AppColors.primaryPurple,
                ),
                const SizedBox(height: 8),
                _buildInfoItem(
                  icon: Icons.play_circle_outline,
                  text: '$videoCount Video',
                ),
                const SizedBox(height: 8),
                _buildInfoItem(
                  icon: Icons.menu_book_outlined,
                  text: '$ebookCount Ebook (PDF)',
                ),
                const SizedBox(height: 8),
                _buildInfoItem(
                  icon: Icons.card_membership_outlined,
                  text: 'Bersertifikat',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color ?? AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: AppTextStyles.body2.copyWith(
            color: color ?? AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// About Section - Tentang Kursus
  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tentang Kursus Ini",
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Program ini mengintegrasikan pembelajaran teoritis yang relevan dengan aplikasi praktis (hands-on) melalui studi kasus industri nyata. Partisipan akan menguasai berbagai disiplin ilmu digital kunci, termasuk Strategi Pemasaran Digital (Digital Marketing), Produksi Konten Kreatif, Analisis Performa Digital Dasar, dan Pengembangan Portofolio Profesional.",
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),

            // Benefit list
            _buildBenefitItem("Forum diskusi belajar"),
            const SizedBox(height: 8),
            _buildBenefitItem("Sertifikat penyelesaian resmi"),
            const SizedBox(height: 8),
            _buildBenefitItem("Well-prepared learning assets"),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.successGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  /// Payment Details Section
  Widget _buildPaymentSection({
    required String price,
    required String discount,
    required String totalPrice,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Details",
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Harga Kelas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Harga Kelas",
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  price,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Diskon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Diskon",
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  discount,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Divider
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 12),

            // Total Transfer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Transfer",
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  totalPrice,
                  style: AppTextStyles.subtitle1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom Button - Bayar dan Gabung Kursus
  Widget _buildBottomButton(BuildContext context, String courseId) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Bayar dan Gabung Kursus',
            onPressed: () {
              // TODO: Dalam implementasi real, call backend API dulu untuk create transaction
              // Backend akan return: orderId, transactionToken, redirectUrl, expiredAt
              
              // Hardcoded demo data
              final now = DateTime.now();
              final expiredAt = now.add(const Duration(hours: 23, minutes: 59, seconds: 59));
              
              context.push(
                '/kelas/payment/$courseId',
                extra: {
                  'orderId': '#LTR-112456',
                  'totalAmount': 'Rp250.000',
                  'expiredAt': expiredAt,
                  'transactionToken': null, // Will be from backend
                  'redirectUrl': null, // Will be from backend
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
