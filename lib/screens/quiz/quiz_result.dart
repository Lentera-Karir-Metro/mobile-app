import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';

/// Halaman Hasil Quiz
class QuizResultScreen extends StatelessWidget {
  final String quizId;
  final int score; // Score as percentage 0-100
  final int kkm; // KKM/Pass threshold as percentage 0-100
  final bool isPassed;
  final int correctCount;
  final int totalQuestions;
  final String courseTitle;
  final String? courseId; // For navigation back to course

  const QuizResultScreen({
    super.key,
    required this.quizId,
    required this.score,
    required this.kkm,
    required this.isPassed,
    required this.correctCount,
    required this.totalQuestions,
    required this.courseTitle,
    this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Header Banner
          _buildHeader(),

          // Result Card - Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: _buildResultCard(),
            ),
          ),
        ],
      ),
      // Bottom Button - Fixed at bottom
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
      height: 180,
      child: Stack(
        children: [
          // Background banner
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

          // Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CustomBackButton(
                backgroundColor: AppColors.cardBackground,
                iconColor: AppColors.textPrimary,
              ),
            ),
          ),

          // Content - positioned below back button area
          Positioned(
            left: 20,
            right: 20,
            top: 80, // Position right below back button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  courseTitle,
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
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
                      'Score: $score%',
                      style: AppTextStyles.caption.copyWith(color: Colors.white),
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

  Widget _buildResultCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Result Icon
          SvgPicture.asset(
            isPassed ? 'assets/quiz/check.svg' : 'assets/quiz/false.svg',
            width: 60,
            height: 60,
          ),
          const SizedBox(height: 16),

          // Result Title
          Text(
            isPassed ? 'Selamat! Kamu Lulus' : 'Maaf! Kamu belum Lulus',
            style: AppTextStyles.heading4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Score
          RichText(
            text: TextSpan(
              style: AppTextStyles.body1.copyWith(color: AppColors.textSecondary),
              children: [
                const TextSpan(text: 'Score kamu '),
                TextSpan(
                  text: '$score',
                  style: TextStyle(
                    color: isPassed ? const Color(0xFF34C759) : const Color(0xFFFF3B30),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: ' dari KKM $kkm'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Summary info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Total Soal', '$totalQuestions'),
                const SizedBox(height: 8),
                _buildSummaryRow('Jawaban Benar', '$correctCount'),
                const SizedBox(height: 8),
                _buildSummaryRow('Jawaban Salah', '${totalQuestions - correctCount}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: PrimaryButton(
          text: isPassed ? 'Selesai' : 'Ulangi Quiz',
          onPressed: () {
            if (isPassed) {
              // Navigate back to course if courseId is available, otherwise go home
              if (courseId != null && courseId!.isNotEmpty) {
                context.go('/kelas/mulai/$courseId');
              } else {
                context.go('/home');
              }
            } else {
              // Retry quiz - replace current route
              context.pushReplacement('/quiz/$quizId');
            }
          },
        ),
      ),
    );
  }
}
