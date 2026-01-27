import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/data/models/module_model.dart';

/// Model untuk materi item (video/quiz/ebook) dengan status selesai
class MateriMulaiItem {
  final String id;
  final String title;
  final bool isQuiz;
  final bool isEbook;
  final bool isCompleted;
  final bool isLocked;
  final String? ebookUrl;
  final String? quizId; // Quiz ID for quiz modules

  const MateriMulaiItem({
    required this.id,
    required this.title,
    this.isQuiz = false,
    this.isEbook = false,
    this.isCompleted = false,
    this.isLocked = false,
    this.ebookUrl,
    this.quizId,
  });

  /// Factory to create from ModuleModel
  factory MateriMulaiItem.fromModule(ModuleModel module) {
    return MateriMulaiItem(
      id: module.id,
      title: module.title,
      isQuiz: module.type == 'quiz',
      isEbook: module.type == 'ebook',
      isCompleted: module.isCompleted,
      isLocked: module.isLocked,
      ebookUrl: module.type == 'ebook' ? module.ebookUrl : null,
      quizId: module.quizId, // Already String? from ModuleModel
    );
  }
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
/// Sekarang menerima data dinamis dari modules API
class PreviewMulaiKelasWidget extends StatefulWidget {
  final int totalVideos;
  final int completedVideos;
  final List<ModuleModel>? modules; // Dynamic modules from API
  final Function(MateriMulaiItem)? onItemTap;
  final Function(MateriMulaiItem)? onQuizTap;
  final Function(MateriMulaiItem)? onEbookTap;

  const PreviewMulaiKelasWidget({
    super.key,
    required this.totalVideos,
    required this.completedVideos,
    this.modules,
    this.onItemTap,
    this.onQuizTap,
    this.onEbookTap,
  });

  @override
  State<PreviewMulaiKelasWidget> createState() =>
      _PreviewMulaiKelasWidgetState();
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

    // Animation dari 0.18 (collapsed) ke 0.55 (expanded)
    _sizeAnimation = Tween<double>(
      begin: 0.18,
      end: 0.55,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _buildMateriSections();
  }

  @override
  void didUpdateWidget(PreviewMulaiKelasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild sections when modules change (check length and completion status)
    final oldModules = oldWidget.modules;
    final newModules = widget.modules;

    bool shouldRebuild = false;

    // Check if modules list changed
    if (oldModules == null && newModules != null) {
      shouldRebuild = true;
    } else if (oldModules != null && newModules == null) {
      shouldRebuild = true;
    } else if (oldModules != null && newModules != null) {
      if (oldModules.length != newModules.length) {
        shouldRebuild = true;
      } else {
        // Check if any module's completion or lock status changed
        for (int i = 0; i < newModules.length; i++) {
          if (oldModules[i].isCompleted != newModules[i].isCompleted ||
              oldModules[i].isLocked != newModules[i].isLocked) {
            shouldRebuild = true;
            break;
          }
        }
      }
    }

    // Also check if completed videos count changed
    if (oldWidget.completedVideos != widget.completedVideos) {
      shouldRebuild = true;
    }

    if (shouldRebuild) {
      setState(() {
        _buildMateriSections();
      });
    }
  }

  void _buildMateriSections() {
    // Build from dynamic modules if available
    if (widget.modules != null && widget.modules!.isNotEmpty) {
      // Group modules by type for display
      final videoItems = widget.modules!
          .where((m) => m.type == 'video')
          .map((m) => MateriMulaiItem.fromModule(m))
          .toList();

      final quizItems = widget.modules!
          .where((m) => m.type == 'quiz')
          .map((m) => MateriMulaiItem.fromModule(m))
          .toList();

      // Note: E-Book section is removed from preview as per request
      // Ebooks are accessible via filter tabs in mulai_kelas.dart

      materiSections = [];

      if (videoItems.isNotEmpty) {
        materiSections.add(
          MateriMulaiSection(
            title: 'Video Pembelajaran',
            isExpanded: true,
            items: videoItems,
          ),
        );
      }

      if (quizItems.isNotEmpty) {
        materiSections.add(MateriMulaiSection(title: 'Quiz', items: quizItems));
      }
    } else {
      // Empty state - no modules
      materiSections = [];
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: Text(
          'Detail Materi',
          style: AppTextStyles.body1.copyWith(
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
    final isLocked = item.isLocked;

    return InkWell(
      onTap: isLocked
          ? () {
              // Show locked message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selesaikan modul sebelumnya terlebih dahulu'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          : () {
              if (item.isQuiz) {
                widget.onQuizTap?.call(item);
              } else if (item.isEbook) {
                widget.onEbookTap?.call(item);
              } else {
                widget.onItemTap?.call(item);
              }
            },
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              // Icon play/quiz/ebook or lock icon
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.grey.withAlpha(26)
                      : AppColors.primaryPurple.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(6),
                child: isLocked
                    ? Icon(Icons.lock, color: Colors.grey.shade500, size: 18)
                    : SvgPicture.asset(
                        item.isQuiz
                            ? 'assets/preview/quiz.svg'
                            : item.isEbook
                            ? 'assets/preview/ebook.svg'
                            : 'assets/preview/play.svg',
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
                    color: isLocked ? Colors.grey : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Checkmark for completed items or lock icon
              if (isLocked)
                Icon(Icons.lock, color: Colors.grey.shade400, size: 20)
              else if (item.isCompleted)
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
      ),
    );
  }
}
