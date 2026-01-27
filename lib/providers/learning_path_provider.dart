import 'package:flutter/material.dart';
import 'package:lentera_karir/data/models/learning_path_model.dart';
import 'package:lentera_karir/data/repositories/learning_path_repository.dart';

enum LearningPathStatus { initial, loading, loaded, error }

class LearningPathProvider extends ChangeNotifier {
  final LearningPathRepository _learningPathRepository;

  LearningPathProvider(this._learningPathRepository);

  LearningPathStatus _status = LearningPathStatus.initial;
  List<LearningPathModel> _learningPaths = [];
  List<LearningPathEnrollmentModel> _myLearningPaths = [];
  LearningPathModel? _currentLearningPath;
  String? _errorMessage;

  LearningPathStatus get status => _status;
  List<LearningPathModel> get learningPaths => _learningPaths;
  List<LearningPathEnrollmentModel> get myLearningPaths => _myLearningPaths;
  LearningPathModel? get currentLearningPath => _currentLearningPath;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LearningPathStatus.loading;

  List<LearningPathEnrollmentModel> get inProgressPaths =>
      _myLearningPaths.where((p) => !p.isCompleted).toList();

  List<LearningPathEnrollmentModel> get completedPaths =>
      _myLearningPaths.where((p) => p.isCompleted).toList();

  Future<void> loadLearningPaths() async {
    _status = LearningPathStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _learningPaths = await _learningPathRepository.getLearningPaths();
      _status = LearningPathStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat learning paths: $e';
      _status = LearningPathStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadLearningPathDetail(String pathId) async {
    _status = LearningPathStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentLearningPath = await _learningPathRepository
          .getLearningPathDetail(pathId);
      _status = LearningPathStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat detail learning path';
      _status = LearningPathStatus.error;
    }

    notifyListeners();
  }

  /// Load learning path with progress data (requires auth)
  /// Use this for enrolled users to see completion status
  /// Falls back to catalog endpoint if authenticated endpoint fails
  Future<void> loadLearningPathContent(String pathId) async {
    _status = LearningPathStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Try authenticated endpoint first for progress data
      _currentLearningPath = await _learningPathRepository
          .getLearningPathContent(pathId);
      
      // If null, fallback to public catalog endpoint
      _currentLearningPath ??= await _learningPathRepository
            .getLearningPathDetail(pathId);
      
      _status = LearningPathStatus.loaded;
    } catch (e) {
      // Fallback to catalog endpoint on error
      try {
        _currentLearningPath = await _learningPathRepository
            .getLearningPathDetail(pathId);
        _status = LearningPathStatus.loaded;
      } catch (e2) {
        _errorMessage = 'Gagal memuat learning path';
        _status = LearningPathStatus.error;
      }
    }

    notifyListeners();
  }

  Future<void> loadMyLearningPaths() async {
    _status = LearningPathStatus.loading;
    notifyListeners();

    try {
      _myLearningPaths = await _learningPathRepository.getMyLearningPaths();
      _status = LearningPathStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat learning paths saya: $e';
      _status = LearningPathStatus.error;
    }

    notifyListeners();
  }

  void clearCurrentPath() {
    _currentLearningPath = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
