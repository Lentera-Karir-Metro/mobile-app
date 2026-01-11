import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/kelas/card_detail_kelas.dart';
import 'package:lentera_karir/widgets/kelas/preview.dart';

/// Halaman detail kelas sesuai design SVG
class DetailKelasScreen extends StatefulWidget {
  final String courseId;
  final bool isPurchased;

  const DetailKelasScreen({
    super.key,
    required this.courseId,
    this.isPurchased = false,
  });

  @override
  State<DetailKelasScreen> createState() => _DetailKelasScreenState();
}

class _DetailKelasScreenState extends State<DetailKelasScreen> {
  // TODO: Replace with actual API data
  final String coursePrice = "Rp 4.999.225";
  final String thumbnailPath = "assets/hardcode/sample_image.png";
  final int videoCount = 22;
  final int ebookCount = 15;
  final String courseDescription =
      "Program pelatihan intensif yang dirancang khusus untuk memfasilitasi individu, baik fresh graduate maupun profesional yang berkeinginan melakukan career pivot, untuk memasuki industri digital bekal pengetahuan dan keterampilan yang relevan.\n\nKurikulum program ini disusun berdasarkan kebutuhan pasar kerja saat ini, dengan fokus pada tiga pilar utama: penguasaan mindset digital, implementasi keterampilan teknis dasar (seperti SEO, copywriting, dan analisis data sederhana), serta strategi profesional dalam pengembangan personal branding dan portofolio.";

  @override
  Widget build(BuildContext context) {
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
                // Header dengan banner
                _buildHeader(),

                // Course Card
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: CardDetailKelas(
                    thumbnailPath: thumbnailPath,
                    price: coursePrice,
                    lifetimeText: "Lifetime Access",
                    videoText: "$videoCount Video",
                    ebookText: "$ebookCount Ebook (PDF)",
                    certificateText: "Bersertifikat",
                  ),
                ),

                // About Section
                _buildAboutSection(),

                // Mentor Section
                if (!widget.isPurchased) _buildMentorSection(),

                // Space untuk bottom sheet preview
                const SizedBox(height: 200),
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

          // Preview Widget - Bottom Sheet menggunakan DraggableScrollableSheet
          PreviewWidget(
            price: coursePrice,
            totalVideos: videoCount,
            completedVideos: 0,
            onBuyTap: () {
              context.push('/kelas/beli/${widget.courseId}');
            },
          ),
        ],
      ),
    );
  }

  /// Header dengan banner image dan info
  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Stack(
        children: [
          // Background banner image - full cover with rounded corners
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
                  'Bootcamp: Kick-start\nKarier Digital',
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

  /// About Section
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
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tentang Kelas",
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              courseDescription,
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textPrimary,
                ),
                children: const [
                  TextSpan(
                    text: "Tujuan Utama: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "Menghasilkan lulusan yang siap kerja (job-ready) dan mampu memberikan kontribusi signifikan dalam lingkungan kerja digital yang dinamis dan kompetitif.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mentor Section
  Widget _buildMentorSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mentor",
              style: AppTextStyles.heading4.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/hardcode/image_profile.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ridho Dwi Syahputra",
                        style: AppTextStyles.subtitle1.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Co-Founder",
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "@bijaktechno, Lecturer",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
