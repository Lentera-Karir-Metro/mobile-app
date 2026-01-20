class QuizResultModel {
  final String id;
  final String userId;
  final String quizId;
  final int score; // Score as percentage 0-100
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final bool isPassed;
  final int attemptNumber;
  final int timeTaken;
  final int passThreshold; // Pass threshold as percentage 0-100
  final DateTime? startedAt;
  final DateTime? completedAt;
  final List<QuestionResultModel> questionResults;

  QuizResultModel({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.score,
    this.totalQuestions = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.isPassed = false,
    this.attemptNumber = 1,
    this.timeTaken = 0,
    this.passThreshold = 75,
    this.startedAt,
    this.completedAt,
    this.questionResults = const [],
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    // Backend returns score as decimal (0-1), convert to percentage (0-100)
    final rawScore = _parseDoubleSafe(json['score']) ?? 0.0;
    final scorePercent = rawScore <= 1.0 ? (rawScore * 100).round() : rawScore.round();
    
    // Backend returns pass_threshold as decimal (0-1), convert to percentage (0-100)
    final rawThreshold = _parseDoubleSafe(json['pass_threshold'] ?? json['passThreshold']) ?? 0.75;
    final thresholdPercent = rawThreshold <= 1.0 ? (rawThreshold * 100).round() : rawThreshold.round();
    
    return QuizResultModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? json['userId']?.toString() ?? '',
      quizId: json['quiz_id']?.toString() ?? json['quizId']?.toString() ?? '',
      score: scorePercent,
      totalQuestions: _parseIntSafe(json['total_questions'] ?? json['totalQuestions']) ?? 0,
      correctAnswers: _parseIntSafe(json['correct_count'] ?? json['correct_answers'] ?? json['correctAnswers']) ?? 0,
      wrongAnswers: _parseIntSafe(json['wrong_answers'] ?? json['wrongAnswers']) ?? 0,
      isPassed: json['is_passed'] ?? json['isPassed'] ?? false,
      attemptNumber: _parseIntSafe(json['attempt_number'] ?? json['attemptNumber']) ?? 1,
      timeTaken: _parseIntSafe(json['time_taken'] ?? json['timeTaken']) ?? 0,
      passThreshold: thresholdPercent,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'].toString())
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'].toString())
          : null,
      questionResults: (json['question_results'] as List? ?? [])
          .map((e) => QuestionResultModel.fromJson(e))
          .toList(),
    );
  }

  static int? _parseIntSafe(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDoubleSafe(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  String get scorePercentage => '${score.toStringAsFixed(0)}%';

  String get formattedTimeTaken {
    if (timeTaken < 60) return '$timeTaken detik';
    final minutes = timeTaken ~/ 60;
    final seconds = timeTaken % 60;
    if (seconds == 0) return '$minutes menit';
    return '$minutes menit $seconds detik';
  }

  String get resultText => isPassed ? 'Lulus' : 'Tidak Lulus';
}

class QuestionResultModel {
  final String questionId;
  final String question;
  final String? selectedOptionId;
  final String? selectedAnswer;
  final String? correctOptionId;
  final String? correctAnswer;
  final bool isCorrect;

  QuestionResultModel({
    required this.questionId,
    required this.question,
    this.selectedOptionId,
    this.selectedAnswer,
    this.correctOptionId,
    this.correctAnswer,
    this.isCorrect = false,
  });

  factory QuestionResultModel.fromJson(Map<String, dynamic> json) {
    return QuestionResultModel(
      questionId: json['question_id']?.toString() ?? json['questionId']?.toString() ?? '',
      question: json['question'] ?? '',
      selectedOptionId: json['selected_option_id']?.toString() ?? json['selectedOptionId']?.toString(),
      selectedAnswer: json['selected_answer'] ?? json['selectedAnswer'],
      correctOptionId: json['correct_option_id']?.toString() ?? json['correctOptionId']?.toString(),
      correctAnswer: json['correct_answer'] ?? json['correctAnswer'],
      isCorrect: json['is_correct'] ?? json['isCorrect'] ?? false,
    );
  }
}
