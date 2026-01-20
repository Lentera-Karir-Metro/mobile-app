import 'package:flutter/material.dart';
import 'package:lentera_karir/data/models/quiz_model.dart';
import 'package:lentera_karir/data/models/question_model.dart';
import 'package:lentera_karir/data/models/quiz_result_model.dart';
import 'package:lentera_karir/data/repositories/quiz_repository.dart';

enum QuizStatus {
  initial,
  loading,
  ready,
  inProgress,
  submitting,
  completed,
  error,
}

class QuizProvider extends ChangeNotifier {
  final QuizRepository _quizRepository;

  QuizProvider(this._quizRepository);

  QuizStatus _status = QuizStatus.initial;
  QuizStartModel? _quizStart;
  QuizResultModel? _result;
  String? _errorMessage;

  // Quiz state
  int _currentQuestionIndex = 0;
  Map<String, String?> _selectedAnswers = {};  // questionId -> optionId (both String)
  String? _currentAttemptId;

  QuizStatus get status => _status;
  QuizStartModel? get quizStart => _quizStart;
  QuizResultModel? get result => _result;
  String? get errorMessage => _errorMessage;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalQuestions => _quizStart?.quiz.questions.length ?? 0;
  String? get attemptId => _currentAttemptId;
  bool get isLoading =>
      _status == QuizStatus.loading || _status == QuizStatus.submitting;

  QuestionModel? get currentQuestion {
    if (_quizStart == null || _quizStart!.quiz.questions.isEmpty) return null;
    if (_currentQuestionIndex >= _quizStart!.quiz.questions.length) return null;
    return _quizStart!.quiz.questions[_currentQuestionIndex];
  }

  String? getSelectedAnswer(String questionId) => _selectedAnswers[questionId];

  bool get canGoNext => _currentQuestionIndex < totalQuestions - 1;
  bool get canGoPrevious => _currentQuestionIndex > 0;
  bool get isLastQuestion => _currentQuestionIndex == totalQuestions - 1;

  int get answeredCount =>
      _selectedAnswers.values.where((v) => v != null).length;
  double get progress =>
      totalQuestions > 0 ? answeredCount / totalQuestions : 0;

  /// Start a quiz - this calls backend to create an attempt
  Future<void> startQuiz(String quizId) async {
    _status = QuizStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _quizStart = await _quizRepository.startQuiz(quizId);
      if (_quizStart != null) {
        _currentAttemptId = _quizStart!.attemptId;
        _status = QuizStatus.ready;
        _resetQuizState();
      } else {
        _errorMessage = 'Quiz tidak ditemukan';
        _status = QuizStatus.error;
      }
    } catch (e) {
      _errorMessage = 'Gagal memulai quiz: $e';
      _status = QuizStatus.error;
    }

    notifyListeners();
  }

  void beginQuiz() {
    _status = QuizStatus.inProgress;
    _resetQuizState();
    notifyListeners();
  }

  /// Select and optionally save answer to backend
  Future<void> selectAnswer(String questionId, String optionId) async {
    _selectedAnswers[questionId] = optionId;
    notifyListeners();

    // Optionally save answer to backend immediately
    if (_currentAttemptId != null) {
      try {
        await _quizRepository.saveAnswer(
          _currentAttemptId!,
          questionId,
          optionId,
        );
      } catch (e) {
        // Silent fail - will be saved on submit
      }
    }
  }

  void nextQuestion() {
    if (canGoNext) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (canGoPrevious) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  Future<QuizResultModel?> submitQuiz() async {
    if (_currentAttemptId == null) return null;

    _status = QuizStatus.submitting;
    notifyListeners();

    try {
      _result = await _quizRepository.submitQuiz(_currentAttemptId!);
      _status = QuizStatus.completed;
      notifyListeners();
      return _result;
    } catch (e) {
      _errorMessage = 'Gagal mengirim jawaban: $e';
      _status = QuizStatus.error;
      notifyListeners();
      return null;
    }
  }

  void _resetQuizState() {
    _currentQuestionIndex = 0;
    _selectedAnswers = <String, String?>{};
    _result = null;
  }

  void resetQuiz() {
    _status = QuizStatus.initial;
    _quizStart = null;
    _result = null;
    _errorMessage = null;
    _currentAttemptId = null;
    _resetQuizState();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
