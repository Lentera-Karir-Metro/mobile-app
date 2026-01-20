import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';
import 'package:lentera_karir/providers/catalog_provider.dart';
import 'package:lentera_karir/providers/payment_provider.dart';

/// Halaman Beli Kelas - menampilkan detail pembayaran sebelum membeli kelas
class BeliKelasScreen extends StatefulWidget {
  final String courseId;

  const BeliKelasScreen({
    super.key,
    required this.courseId,
  });

  @override
  State<BeliKelasScreen> createState() => _BeliKelasScreenState();
}

class _BeliKelasScreenState extends State<BeliKelasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use CatalogProvider (public endpoint, like web frontend)
      context.read<CatalogProvider>().loadCourseDetail(widget.courseId);
    });
  }

  String _formatCurrency(double amount) {
    if (amount == 0) return 'Rp0';
    return 'Rp${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<CatalogProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final course = provider.selectedCourse;
          if (course == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kelas tidak ditemukan',
                    style: AppTextStyles.body1.copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadCourseDetail(widget.courseId),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final courseTitle = course.title;
          final thumbnailPath = course.thumbnailUrl ?? 'assets/hardcode/sample_image.png';
          final priceStr = course.formattedPrice;
          final originalPrice = course.price; // Original price (numeric)
          final discount = course.discountPrice ?? 0; // Discount amount (numeric)
          final totalPrice = originalPrice - discount; // Final price after discount
          final videoCount = course.videoCount ?? course.totalModules;
          final ebookCount = course.ebookCount ?? 0;
          final description = course.description ?? '';

          return Stack(
            children: [
              // Main scrollable content
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Banner
                    _buildHeader(courseTitle, course.createdAt, course.updatedAt),

                    // Course Card dengan thumbnail
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                      child: _buildCourseCard(
                        thumbnailPath: thumbnailPath,
                        price: priceStr,
                        videoCount: videoCount,
                        ebookCount: ebookCount,
                      ),
                    ),

                    // Tentang Kursus Section
                    _buildAboutSection(description),

                    // Payment Details Section
                    _buildPaymentSection(
                      price: _formatCurrency(originalPrice),
                      discount: _formatCurrency(discount),
                      totalPrice: _formatCurrency(totalPrice),
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
                child: _buildBottomButton(context, widget.courseId, totalPrice),
              ),
            ],
          );
        },
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  /// Header dengan banner image dan title
  Widget _buildHeader(String title, DateTime? createdAt, DateTime? updatedAt) {
    // Use current date as fallback if dates are not available
    final now = DateTime.now();
    final releasedDate = createdAt != null
        ? '${createdAt.day} ${_monthName(createdAt.month)} ${createdAt.year}'
        : '${now.day} ${_monthName(now.month)} ${now.year}';
    final lastUpdated = updatedAt != null
        ? '${updatedAt.day} ${_monthName(updatedAt.month)} ${updatedAt.year}'
        : '${now.day} ${_monthName(now.month)} ${now.year}';

    return SizedBox(
      width: double.infinity,
      height: 220, // Match detail_kelas height
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

          // Content - positioned below back button area with small gap (like detail_kelas)
          Positioned(
            left: 20,
            right: 20,
            top: 90, // Position below back button with small gap
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Course Title
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Released date row (separate line)
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/kelas/globe.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Released date $releasedDate',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Last updated row (separate line)
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/kelas/last_update.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last updated $lastUpdated',
                      style: AppTextStyles.caption.copyWith(
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
              child: thumbnailPath.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: thumbnailPath,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      memCacheWidth: 600,
                      memCacheHeight: 300,
                    )
                  : Image.asset(
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
  Widget _buildAboutSection(String description) {
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
              description.isNotEmpty ? description : 'Tidak ada deskripsi',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
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
  Widget _buildBottomButton(BuildContext context, String courseId, double totalAmount) {
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
        child: Consumer<PaymentProvider>(
          builder: (context, paymentProvider, child) {
            return SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: paymentProvider.isLoading ? 'Memproses...' : 'Bayar dan Gabung Kursus',
                onPressed: paymentProvider.isLoading
                    ? null
                    : () async {
                        // Create payment transaction via PaymentProvider
                        await paymentProvider.createPayment(courseId);
                        
                        if (paymentProvider.errorMessage != null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(paymentProvider.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          return;
                        }

                        final payment = paymentProvider.currentPayment;
                        if (payment != null && context.mounted) {
                          // If we have redirect URL, go to webview for payment
                          if (payment.redirectUrl != null && payment.redirectUrl!.isNotEmpty) {
                            context.push(
                              '/payment/webview/$courseId',
                              extra: {
                                'orderId': payment.orderId,
                                'redirectUrl': payment.redirectUrl,
                                'totalAmount': payment.finalPrice,
                              },
                            );
                          } else {
                            // Fallback to original payment screen
                            context.push(
                              '/kelas/payment/$courseId',
                              extra: {
                                'orderId': payment.orderId,
                                'totalAmount': _formatCurrency(payment.finalPrice),
                                'expiredAt': DateTime.now().add(const Duration(hours: 24)),
                                'transactionToken': payment.transactionToken,
                                'redirectUrl': payment.redirectUrl,
                              },
                            );
                          }
                        }
                      },
              ),
            );
          },
        ),
      ),
    );
  }
}
