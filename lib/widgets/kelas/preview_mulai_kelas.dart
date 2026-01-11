import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lentera_karir/styles/styles.dart';

/// Model untuk materi item (video/quiz) dengan status selesai
class MateriMulaiItem {
  final String id;
  final String title;
  final String duration;
  final bool isQuiz;
  final bool isCompleted;

  const MateriMulaiItem({
    required this.id,
    required this.title,
    required this.duration,
    this.isQuiz = false,
    this.isCompleted = false,
  });
}

/// Model untuk section materi
class MateriMulaiSection {
  final String title;
  final List<MateriMulaiItem> items;
  bool isExpanded;

  MateriMulaiSection({
    required this.title,
    required this.items,
    this.isExpanded = false,
  });
}

/// Preview Widget untuk halaman Mulai Kelas - Bottom sheet swipe up/down
/// Mirip dengan preview.dart tapi dengan checklist untuk item yang selesai
class PreviewMulaiKelasWidget extends StatefulWidget {
  final int totalVideos;
  final int completedVideos;
  final Function(MateriMulaiItem)? onItemTap;
  final Function(MateriMulaiItem)? onQuizTap;

  const PreviewMulaiKelasWidget({
    super.key,
    required this.totalVideos,
    required this.completedVideos,
    this.onItemTap,
    this.onQuizTap,
  });

  @override
  State<PreviewMulaiKelasWidget> createState() => _PreviewMulaiKelasWidgetState();
}

class _PreviewMulaiKelasWidgetState extends State<PreviewMulaiKelasWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  bool _isExpanded = false;
  late List<MateriMulaiSection> materiSections;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Animation dari 0.15 (collapsed) ke 0.55 (expanded)
    _sizeAnimation = Tween<double>(
      begin: 0.15,
      end: 0.55,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Dummy data - TODO: Replace with actual API data
    materiSections = [
      MateriMulaiSection(
        title: 'Fundamental & Orientasi Karier Digital',
        isExpanded: true,
        items: [
          const MateriMulaiItem(id: 'v1', title: 'Analisis Tren', duration: '09:20', isCompleted: true),
          const MateriMulaiItem(id: 'v2', title: 'Pengembangan Digital Mindset', duration: '12:45', isCompleted: true),
          const MateriMulaiItem(id: 'v3', title: 'Manajemen Media Sosial', duration: '15:30', isCompleted: false),
          const MateriMulaiItem(id: 'q1', title: 'Quiz Sesi 1', duration: '18:00', isQuiz: true, isCompleted: false),
        ],
      ),
      MateriMulaiSection(
        title: 'Kompetensi Teknis Dasar',
        items: [
          const MateriMulaiItem(id: 'v4', title: 'SEO & Content Marketing', duration: '14:20', isCompleted: false),
          const MateriMulaiItem(id: 'v5', title: 'Copywriting untuk Digital', duration: '16:30', isCompleted: false),
          const MateriMulaiItem(id: 'v6', title: 'Analisis Data Sederhana', duration: '18:45', isCompleted: false),
          const MateriMulaiItem(id: 'v7', title: 'Tools Digital Marketing', duration: '12:15', isCompleted: false),
          const MateriMulaiItem(id: 'q2', title: 'Quiz Sesi 2', duration: '20:00', isQuiz: true, isCompleted: false),
        ],
      ),
      MateriMulaiSection(
        title: 'Strategi Pengembangan Professional',
        items: [
          const MateriMulaiItem(id: 'v8', title: 'Personal Branding', duration: '15:30', isCompleted: false),
          const MateriMulaiItem(id: 'v9', title: 'Membangun Portofolio', duration: '17:20', isCompleted: false),
          const MateriMulaiItem(id: 'q3', title: 'Quiz Final', duration: '25:00', isQuiz: true, isCompleted: false),
        ],
      ),
    ];
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
                    color: Colors.black.withAlpha(38),
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

                  // Content
                  Expanded(
                    child: _isExpanded
                        ? _buildExpandedContent()
                        : _buildCollapsedContent(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCollapsedContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Video count di kiri
          Text(
            '${widget.totalVideos} Video',
            style: AppTextStyles.heading4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Progress di kanan
          Text(
            '${widget.completedVideos}/${widget.totalVideos} Selesai',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.totalVideos} Video',
              style: AppTextStyles.subtitle1.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${widget.completedVideos}/${widget.totalVideos} Selesai',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
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

  Widget _buildMateriSection(MateriMulaiSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
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

  Widget _buildMateriItem(MateriMulaiItem item) {
    return InkWell(
      onTap: () {
        if (item.isQuiz) {
          widget.onQuizTap?.call(item);
        } else {
          widget.onItemTap?.call(item);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // Icon play/quiz
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
              child: SvgPicture.asset(
                item.isQuiz ? 'assets/preview/quiz.svg' : 'assets/preview/play.svg',
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryPurple,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Title
            Expanded(
              child: Text(
                item.title,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            // Duration
            Text(
              item.duration,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Checkmark for completed items
            if (item.isCompleted)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF34C759),
                size: 20,
              )
            else
              Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey.shade400,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
