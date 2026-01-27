import 'package:lentera_karir/data/models/quiz_model.dart';
import 'package:lentera_karir/data/models/quiz_result_model.dart';
import 'package:lentera_karir/data/services/quiz_service.dart';

abstract class QuizRepository {
  Future<QuizStartModel?> startQuiz(String quizId);
  Future<bool> saveAnswer(String attemptId, String questionId, String selectedOptionId);
  Future<QuizResultModel?> submitQuiz(String attemptId);
}

class QuizRepositoryImpl implements QuizRepository {
  final QuizService _quizService;

  QuizRepositoryImpl(this._quizService);

  @override
  Future<QuizStartModel?> startQuiz(String quizId) async {
    try {
      final response = await _quizService.startQuiz(quizId);
      if (response['success'] == true && response['data'] != null) {
        return QuizStartModel.fromJson(response['data']);
      }
    } catch (_) {
      // Error logged - removed print for production
    }
    return null;
  }

  @override
  Future<bool> saveAnswer(
    String attemptId,
    String questionId,
    String selectedOptionId,
  ) async {
    try {
      final response = await _quizService.saveAnswer(
        attemptId,
        questionId: questionId,
        selectedOptionId: selectedOptionId,
      );
      return response['success'] == true;
    } catch (_) {
      // Error logged - removed print for production
      return false;
    }
  }

  @override
  Future<QuizResultModel?> submitQuiz(String attemptId) async {
    try {
      final response = await _quizService.submitQuiz(attemptId);
      if (response['success'] == true && response['data'] != null) {
        return QuizResultModel.fromJson(response['data']);
      }
    } catch (_) {
      // Error logged - removed print for production
    }
    return null;
  }
}
