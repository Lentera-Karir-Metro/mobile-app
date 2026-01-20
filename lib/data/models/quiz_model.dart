import 'package:lentera_karir/data/models/question_model.dart';

class QuizModel {
  final String id;
  final String? moduleId;
  final String? courseId;
  final String title;
  final String? description;
  final int totalQuestions;
  final int duration;
  final int passingScore;
  final int maxAttempts;
  final bool isCompleted;
  final bool isPassed;
  final List<QuestionModel> questions;

  QuizModel({
    required this.id,
    this.moduleId,
    this.courseId,
    required this.title,
    this.description,
    this.totalQuestions = 0,
    this.duration = 0,
    this.passingScore = 70,
    this.maxAttempts = 3,
    this.isCompleted = false,
    this.isPassed = false,
    this.questions = const [],
  });

  static int _parseIntSafe(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static int _parsePassingScore(dynamic value, [int defaultValue = 75]) {
    if (value == null) return defaultValue;
    double numValue;
    if (value is double) {
      numValue = value;
    } else if (value is int) {
      numValue = value.toDouble();
    } else if (value is String) {
      numValue = double.tryParse(value) ?? defaultValue.toDouble();
    } else {
      return defaultValue;
    }
    // If value is <= 1, treat as decimal (0-1) and convert to percentage
    if (numValue <= 1.0) {
      return (numValue * 100).round();
    }
    return numValue.round();
  }

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id']?.toString() ?? '',
      moduleId: json['module_id']?.toString() ?? json['moduleId']?.toString(),
      courseId: json['course_id']?.toString() ?? json['courseId']?.toString(),
      title: json['title'] ?? '',
      description: json['description'],
      totalQuestions: _parseIntSafe(json['total_questions'] ?? json['totalQuestions']),
      duration: _parseIntSafe(json['duration']),
      passingScore: _parsePassingScore(json['pass_threshold'] ?? json['passing_score'] ?? json['passingScore'], 75),
      maxAttempts: _parseIntSafe(json['max_attempts'] ?? json['maxAttempts'], 3),
      isCompleted: json['is_completed'] ?? json['isCompleted'] ?? false,
      isPassed: json['is_passed'] ?? json['isPassed'] ?? false,
      questions: (json['questions'] as List? ?? [])
          .map((e) => QuestionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'course_id': courseId,
      'title': title,
      'description': description,
      'total_questions': totalQuestions,
      'duration': duration,
      'passing_score': passingScore,
      'max_attempts': maxAttempts,
      'is_completed': isCompleted,
      'is_passed': isPassed,
    };
  }

  String get formattedDuration {
    if (duration < 60) return '$duration menit';
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (minutes == 0) return '$hours jam';
    return '$hours jam $minutes menit';
  }
}

/// Model untuk response dari POST /learn/quiz/:quiz_id/start
class QuizStartModel {
  final String attemptId;
  final QuizModel quiz;
  final Map<String, String> savedAnswers; // question_id -> selected_option_id
  final int? bestScore; // Best score from previous completed attempts
  final DateTime? bestScoreDate; // Date of best score
  final bool hasPassed; // Whether user has passed the quiz before

  QuizStartModel({
    required this.attemptId,
    required this.quiz,
    this.savedAnswers = const {},
    this.bestScore,
    this.bestScoreDate,
    this.hasPassed = false,
  });

  factory QuizStartModel.fromJson(Map<String, dynamic> json) {
    // Parse saved answers jika ada (untuk resume)
    Map<String, String> answers = {};
    if (json['saved_answers'] != null) {
      final savedList = json['saved_answers'] as List? ?? [];
      for (var answer in savedList) {
        final qId = answer['question_id']?.toString();
        final optId = answer['selected_option_id']?.toString();
        if (qId != null && optId != null) {
          answers[qId] = optId;
        }
      }
    }

    return QuizStartModel(
      attemptId: json['attempt_id']?.toString() ?? json['attemptId']?.toString() ?? '',
      quiz: QuizModel.fromJson(json['quiz'] ?? json),
      savedAnswers: answers,
      // Backend sends score as decimal (0.0-1.0), convert to percentage (0-100)
      bestScore: json['best_score'] != null ? ((json['best_score'] as num) * 100).round() : null,
      bestScoreDate: json['best_score_date'] != null ? DateTime.tryParse(json['best_score_date'].toString()) : null,
      hasPassed: json['has_passed'] ?? false,
    );
  }
}
