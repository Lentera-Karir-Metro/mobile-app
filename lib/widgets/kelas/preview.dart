import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';
import 'package:lentera_karir/data/models/module_model.dart';

/// Model untuk materi item (video/quiz/ebook)
class MateriItem {
  final String title;
  final String duration;
  final bool isQuiz;
  final bool isEbook;

  const MateriItem({
    required this.title,
    required this.duration,
    this.isQuiz = false,
    this.isEbook = false,
  });
}

/// Model untuk section materi
class MateriSection {
  final String title;
  final List<MateriItem> items;
  bool isExpanded;

  MateriSection({
    required this.title,
    required this.items,
    this.isExpanded = false,
  });
}

/// Preview Widget - Bottom sheet yang bisa swipe up/down
class PreviewWidget extends StatefulWidget {
  final String price;
  final int totalVideos;
  final int completedVideos;
  final VoidCallback onBuyTap;
  final VoidCallback? onStartTap;
  final bool isEnrolled;
  final bool isCheckingEnrollment;
  final List<ModuleModel>? modules; // Backend modules

  const PreviewWidget({
    super.key,
    required this.price,
    this.totalVideos = 22,
    this.completedVideos = 0,
    required this.onBuyTap,
    this.onStartTap,
    this.isEnrolled = false,
    this.isCheckingEnrollment = false,
    this.modules,
  });

  @override
  State<PreviewWidget> createState() => _PreviewWidgetState();
}

class _PreviewWidgetState extends State<PreviewWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  bool _isExpanded = false;
  late List<MateriSection> materiSections;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Animation dari 0.22 (collapsed) ke 0.55 (expanded) - tidak menutupi banner
    _sizeAnimation = Tween<double>(
      begin: 0.22,
      end: 0.55,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Use backend modules if available, otherwise use placeholder
    if (widget.modules != null && widget.modules!.isNotEmpty) {
      materiSections = [
        MateriSection(
          title: 'Daftar Modul',
          isExpanded: true,
          items: widget.modules!.map((m) {
            final isQuiz = m.quizId != null || m.type == 'quiz';
            final hasVideo = m.videoUrl != null && m.videoUrl!.isNotEmpty;
            final hasEbook = m.ebookUrl != null && m.ebookUrl!.isNotEmpty;

            String duration = 'Video';
            if (hasVideo) {
              duration = 'Video';
            } else if (hasEbook) {
              duration = 'PDF';
            } else if (isQuiz) {
              duration = 'Quiz';
            }

            return MateriItem(
              title: m.title,
              duration: duration,
              isQuiz: isQuiz,
              isEbook: hasEbook,
            );
          }).toList(),
        ),
      ];
    } else {
      // Fallback dummy data
      materiSections = [
        MateriSection(
          title: 'Fundamental & Orientasi Karier Digital',
          isExpanded: true,
          items: [
            const MateriItem(title: 'Analisis Tren', duration: '09:20'),
            const MateriItem(
              title: 'Pengembangan Digital Mindset',
              duration: '12:45',
            ),
            const MateriItem(
              title: 'Manajemen Media Sosial',
              duration: '15:30',
            ),
            const MateriItem(
              title: 'Quiz Sesi 1',
              duration: '18:00',
              isQuiz: true,
            ),
          ],
        ),
        MateriSection(
          title: 'Kompetensi Teknis Dasar',
          items: [
            const MateriItem(
              title: 'SEO & Content Marketing',
              duration: '14:20',
            ),
            const MateriItem(
              title: 'Copywriting untuk Digital',
              duration: '16:30',
            ),
            const MateriItem(
              title: 'Analisis Data Sederhana',
              duration: '18:45',
            ),
            const MateriItem(
              title: 'Tools Digital Marketing',
              duration: '12:15',
            ),
            const MateriItem(
              title: 'Quiz Sesi 2',
              duration: '20:00',
              isQuiz: true,
            ),
          ],
        ),
        MateriSection(
          title: 'Strategi Pengembangan Professional',
          items: [
            const MateriItem(title: 'Personal Branding', duration: '15:30'),
            const MateriItem(title: 'Membangun Portofolio', duration: '17:20'),
            const MateriItem(title: 'Networking & LinkedIn', duration: '13:45'),
            const MateriItem(title: 'Career Planning', duration: '16:00'),
            const MateriItem(
              title: 'Quiz Final',
              duration: '25:00',
              isQuiz: true,
            ),
          ],
        ),
      ];
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _sizeAnimation,
      builder: (context, child) {
        final currentHeight = screenHeight * _sizeAnimation.value;

        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: currentHeight,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! < -10 && !_isExpanded) {
                _toggleExpand();
              } else if (details.primaryDelta! > 10 && _isExpanded) {
                _toggleExpand();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Drag handle
                  GestureDetector(
                    onTap: _toggleExpand,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Content - menggunakan Expanded agar fleksibel
                  Expanded(
                    child: _isExpanded
                        ? _buildExpandedContent()
                        : _buildCollapsedContent(),
                  ),

                  // Buy Button - fixed height
                  _buildBuyButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCollapsedContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Detail Materi',
          style: AppTextStyles.subtitle1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Center(
          child: Text(
            'Detail Materi',
            style: AppTextStyles.subtitle1.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Harga:',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              widget.price,
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Daftar Materi',
          style: AppTextStyles.heading4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...materiSections.map((section) => _buildMateriSection(section)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMateriSection(MateriSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                section.isExpanded = !section.isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(
                    section.isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      section.title,
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (section.isExpanded)
            Column(
              children: [
                Divider(height: 1, color: Colors.grey.shade200),
                ...section.items.map((item) => _buildMateriItem(item)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMateriItem(MateriItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              item.isQuiz
                  ? 'assets/preview/quiz.svg'
                  : item.isEbook
                  ? 'assets/preview/ebook.svg'
                  : 'assets/preview/play.svg',
              colorFilter: ColorFilter.mode(
                AppColors.primaryPurple,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.title,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            item.duration,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton() {
    // Show loading while checking enrollment
    if (widget.isCheckingEnrollment) {
      return SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: const SizedBox(
            width: double.infinity,
            height: 48,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    // Show different button based on enrollment status
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: widget.isEnrolled ? 'Mulai Belajar' : 'Beli Kelas',
            onPressed: widget.isEnrolled
                ? (widget.onStartTap ?? widget.onBuyTap)
                : widget.onBuyTap,
          ),
        ),
      ),
    );
  }
}
