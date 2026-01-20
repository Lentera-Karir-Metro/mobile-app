import 'package:lentera_karir/data/api/api_service.dart';
import 'package:lentera_karir/data/api/endpoints.dart';

class QuizService {
  final ApiService _apiService;

  QuizService(this._apiService);

  // Start or resume quiz (POST) - returns quiz data and attempt_id
  Future<Map<String, dynamic>> startQuiz(String quizId) async {
    return await _apiService.post(
      ApiEndpoints.startQuiz(quizId),
      body: {},
    );
  }

  // Save partial answer (POST) - untuk fitur resume
  Future<Map<String, dynamic>> saveAnswer(
    String attemptId, {
    required String questionId,
    required String selectedOptionId,
  }) async {
    return await _apiService.post(
      ApiEndpoints.saveQuizAnswer(attemptId),
      body: {
        'question_id': questionId,
        'selected_option_id': selectedOptionId,
      },
    );
  }

  // Submit quiz for grading (POST)
  Future<Map<String, dynamic>> submitQuiz(String attemptId) async {
    return await _apiService.post(
      ApiEndpoints.submitQuiz(attemptId),
      body: {},
    );
  }
}
