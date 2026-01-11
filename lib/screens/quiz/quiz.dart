import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lentera_karir/styles/styles.dart';
import 'package:lentera_karir/widgets/universal/buttons/back_button.dart';
import 'package:lentera_karir/widgets/universal/buttons/primary_button.dart';

/// Model untuk pertanyaan quiz
class QuizQuestion {
  final int id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}

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
  // Quiz data
  final String courseTitle = "Bootcamp: Kick-start Karier Digital";
  final int kkm = 60; // Nilai KKM
  
  // Dummy questions
  final List<QuizQuestion> questions = const [
    QuizQuestion(
      id: 1,
      question: 'Prinsip utama Digital Mindset yang mendorong eksperimen dan peningkatan berkelanjutan dalam lingkungan kerja yang serba cepat adalah...',
      options: ['Fixed Budget', 'Top-Down Hierarchy', 'Agility (Ketangkasan)', 'Waterfall Method'],
      correctAnswerIndex: 2,
    ),
    QuizQuestion(
      id: 2,
      question: 'Aktivitas yang termasuk dalam kategori Off-Page SEO adalah...',
      options: ['Pembangunan backlink berkualitas dari situs otoritatif', 'Optimasi kecepatan website', 'Perbaikan struktur URL', 'Penggunaan tag H1 yang relevan'],
      correctAnswerIndex: 0,
    ),
    QuizQuestion(
      id: 3,
      question: 'Call-to-Action (CTA) yang efektif sebaiknya menggunakan bahasa yang pasif dan umum agar audiens tidak merasa tertekan.',
      options: ['TRUE', 'FALSE'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      id: 4,
      question: 'Organic Traffic adalah pengunjung yang datang ke website melalui tautan iklan berbayar (PPC) di mesin pencari.',
      options: ['TRUE', 'FALSE'],
      correctAnswerIndex: 1,
    ),
    QuizQuestion(
      id: 5,
      question: 'Mengapa Content Pillar (Pilar Konten) penting dalam strategi media sosial?',
      options: [
        'Untuk memastikan setiap post diiklankan',
        'Untuk menentukan jam posting terbaik',
        'Untuk membatasi jumlah platform yang digunakan',
        'Untuk menjaga konsistensi tema dan relevansi konten'
      ],
      correctAnswerIndex: 3,
    ),
  ];

  // State
  final Map<int, int> _selectedAnswers = {};
  bool _showConfirmDialog = false;

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

                // Quiz Content Card
                _buildQuizCard(),

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
            child: _buildBottomButton(),
          ),

          // Confirm Dialog
          if (_showConfirmDialog) _buildConfirmDialog(),
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

  Widget _buildQuizCard() {
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
            return _buildQuestionItem(index + 1, question);
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(int number, QuizQuestion question) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Text(
            '$number. ${question.question}',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // Options
          ...question.options.asMap().entries.map((entry) {
            final optionIndex = entry.key;
            final optionText = entry.value;
            final isSelected = _selectedAnswers[question.id] == optionIndex;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildOptionItem(
                text: optionText,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedAnswers[question.id] = optionIndex;
                  });
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

  Widget _buildBottomButton() {
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
          text: 'Submit Quiz',
          onPressed: () {
            setState(() {
              _showConfirmDialog = true;
            });
          },
        ),
      ),
    );
  }

  Widget _buildConfirmDialog() {
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
                        _submitQuiz();
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

  void _submitQuiz() {
    // Calculate score
    int correctCount = 0;
    for (var question in questions) {
      if (_selectedAnswers[question.id] == question.correctAnswerIndex) {
        correctCount++;
      }
    }
    
    final score = ((correctCount / questions.length) * 100).round();
    final isPassed = score >= kkm;

    // Navigate to result
    context.push(
      '/quiz/result/${widget.quizId}',
      extra: {
        'score': score,
        'kkm': kkm,
        'isPassed': isPassed,
        'correctCount': correctCount,
        'totalQuestions': questions.length,
        'questions': questions,
        'selectedAnswers': _selectedAnswers,
        'courseTitle': courseTitle,
      },
    );
  }
}
