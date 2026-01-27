import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';
import 'package:lentera_karir/providers/quiz_provider.dart';

/// Halaman Quiz - mengerjakan soal-soal quiz
class QuizScreen extends StatefulWidget {
  final String quizId;

  const QuizScreen({
    super.key,
    required this.quizId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _showConfirmDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().startQuiz(widget.quizId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.quizStart == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.errorMessage != null && provider.quizStart == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage!,
                    style: AppTextStyles.body1.copyWith(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.startQuiz(widget.quizId),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.quizStart == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: const Center(child: Text('Quiz tidak ditemukan')),
          );
        }

        final quiz = provider.quizStart!.quiz;
        final courseTitle = quiz.title;
        final kkm = quiz.passingScore;
        final courseId = quiz.courseId;
        final bestScore = provider.quizStart!.bestScore;

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Stack(
            children: [
              // Main content
              Column(
                children: [
                  // Header Banner
                  _buildHeader(courseTitle, kkm, bestScore),

                  // Quiz Content Card - Scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildQuizCard(provider),
                    ),
                  ),
                ],
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

              // Confirm Dialog
              if (_showConfirmDialog) _buildConfirmDialog(provider, courseId),
            ],
          ),
          // Bottom Button - Fixed at bottom using bottomNavigationBar
          bottomNavigationBar: _buildBottomButton(provider),
        );
      },
    );
  }

  Widget _buildHeader(String courseTitle, int kkm, int? bestScore) {
    return SizedBox(
      width: double.infinity,
      height: 200,
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

          // Content - positioned below back button area with small gap
          Positioned(
            left: 20,
            right: 20,
            top: 90, // Position below back button with small gap
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
                      bestScore != null 
                          ? 'Best Score: $bestScore' 
                          : 'Best Score: -',
                      style: AppTextStyles.caption.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
                      'KKM: $kkm',
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

  Widget _buildQuizCard(QuizProvider provider) {
    final questions = provider.quizStart?.quiz.questions ?? [];
    
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quiz Title
          Text(
            'Final Quiz',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Questions
          ...questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return _buildQuestionItem(index + 1, question, provider);
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(int number, dynamic question, QuizProvider provider) {
    final String questionId = question.id?.toString() ?? '';
    final questionText = question.question ?? question.text ?? '';
    final options = question.options ?? [];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Text(
            '$number. $questionText',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Options - use option.id (String) instead of index
          ...options.map((option) {
            final String optionId = option.id?.toString() ?? '';
            final optionText = option.text ?? option.toString();
            final selectedAnswer = provider.getSelectedAnswer(questionId);
            final isSelected = selectedAnswer == optionId;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildOptionItem(
                text: optionText,
                isSelected: isSelected,
                onTap: () {
                  provider.selectAnswer(questionId, optionId);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryPurple.withAlpha(26)
              : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryPurple 
                : Colors.black.withAlpha(26),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.body2.copyWith(
            color: isSelected 
                ? AppColors.primaryPurple 
                : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(QuizProvider provider) {
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
          text: provider.isLoading ? 'Memproses...' : 'Submit Quiz',
          onPressed: provider.isLoading ? null : () {
            setState(() {
              _showConfirmDialog = true;
            });
          },
        ),
      ),
    );
  }

  Widget _buildConfirmDialog(QuizProvider provider, String? courseId) {
    return Container(
      color: Colors.black.withAlpha(128),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              SvgPicture.asset(
                'assets/quiz/tanya.svg',
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Selesaikan?',
                style: AppTextStyles.heading4.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Apa kamu yakin untuk menyelesaikan quiz ini?',
                textAlign: TextAlign.center,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  // Selesai button
                  Expanded(
                    child: PrimaryButton(
                      text: 'Selesai',
                      onPressed: () {
                        _submitQuiz(provider, courseId);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Batal button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showConfirmDialog = false;
                        });
                      },
                      child: Container(
                        height: AppDimensions.buttonHeight,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
                          border: Border.all(
                            color: AppColors.textSecondary.withAlpha(77),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Batal',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitQuiz(QuizProvider provider, String? courseId) async {
    setState(() {
      _showConfirmDialog = false;
    });
    
    // Submit quiz via provider
    await provider.submitQuiz();
    
    if (provider.result != null && mounted) {
      final result = provider.result!;
      
      // Navigate to result - use score and passThreshold from result model (already in percentage 0-100)
      context.pushReplacement(
        '/quiz/result/${widget.quizId}',
        extra: {
          'score': result.score, // Already percentage 0-100
          'kkm': result.passThreshold, // Already percentage 0-100
          'isPassed': result.isPassed,
          'correctCount': result.correctAnswers,
          'totalQuestions': result.totalQuestions,
          'courseTitle': provider.quizStart?.quiz.title ?? 'Quiz',
          'courseId': courseId, // Pass courseId for navigation back to course
        },
      );
    } else if (provider.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
