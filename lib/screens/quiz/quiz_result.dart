import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';
import 'package:lentera_karir/screens/quiz/quiz.dart';

/// Halaman Hasil Quiz
class QuizResultScreen extends StatelessWidget {
  final String quizId;
  final int score;
  final int kkm;
  final bool isPassed;
  final int correctCount;
  final int totalQuestions;
  final List<QuizQuestion> questions;
  final Map<int, int> selectedAnswers;
  final String courseTitle;

  const QuizResultScreen({
    super.key,
    required this.quizId,
    required this.score,
    required this.kkm,
    required this.isPassed,
    required this.correctCount,
    required this.totalQuestions,
    required this.questions,
    required this.selectedAnswers,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                // Header Banner
                _buildHeader(),

                // Result Card
                _buildResultCard(),

                const SizedBox(height: 100),
              ],
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

          // Bottom Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
      height: 220,
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

          // Content
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
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
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.public_rounded, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Released date March 2025',
                      style: AppTextStyles.caption.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.update_rounded, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Last updated August 2025',
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

          // Answer Review
          ...questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            final selectedIndex = selectedAnswers[question.id];
            final isCorrect = selectedIndex == question.correctAnswerIndex;

            return _buildAnswerReview(
              number: index + 1,
              question: question,
              selectedIndex: selectedIndex,
              isCorrect: isCorrect,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnswerReview({
    required int number,
    required QuizQuestion question,
    required int? selectedIndex,
    required bool isCorrect,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Text(
            '$number. ${question.question}',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),

          // Options with result
          ...question.options.asMap().entries.map((entry) {
            final optionIndex = entry.key;
            final optionText = entry.value;
            final isSelected = selectedIndex == optionIndex;
            final isCorrectAnswer = optionIndex == question.correctAnswerIndex;

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _buildResultOption(
                text: optionText,
                isSelected: isSelected,
                isCorrectAnswer: isCorrectAnswer,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResultOption({
    required String text,
    required bool isSelected,
    required bool isCorrectAnswer,
  }) {
    Color bgColor = AppColors.backgroundColor;
    Color borderColor = Colors.black.withAlpha(26);
    Color textColor = AppColors.textPrimary;
    Widget? trailingIcon;

    if (isSelected && isCorrectAnswer) {
      // Benar
      bgColor = const Color(0xFF34C759).withAlpha(26);
      borderColor = const Color(0xFF34C759);
      textColor = const Color(0xFF34C759);
      trailingIcon = SvgPicture.asset(
        'assets/quiz/check.svg',
        width: 20,
        height: 20,
      );
    } else if (isSelected && !isCorrectAnswer) {
      // Salah - jawaban user
      bgColor = const Color(0xFFFF3B30).withAlpha(26);
      borderColor = const Color(0xFFFF3B30);
      textColor = const Color(0xFFFF3B30);
      trailingIcon = SvgPicture.asset(
        'assets/quiz/false.svg',
        width: 20,
        height: 20,
      );
    } else if (!isSelected && isCorrectAnswer) {
      // Jawaban yang benar (untuk ditandai)
      bgColor = const Color(0xFF34C759).withAlpha(26);
      borderColor = const Color(0xFF34C759);
      textColor = const Color(0xFF34C759);
      trailingIcon = SvgPicture.asset(
        'assets/quiz/check.svg',
        width: 20,
        height: 20,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body3.copyWith(
                color: textColor,
              ),
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            trailingIcon,
          ],
        ],
      ),
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
              // Kembali ke halaman mulai kelas
              context.go('/kelas/mulai/1');
            } else {
              // Ulangi quiz - ke halaman quiz dengan quizId yang sama
              context.go('/quiz/$quizId');
            }
          },
        ),
      ),
    );
  }
}
