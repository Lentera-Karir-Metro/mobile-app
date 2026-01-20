import 'package:flutter/material.dart';
import 'package:lentera_karir/data/models/dashboard_model.dart';
import 'package:lentera_karir/data/repositories/dashboard_repository.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _dashboardRepository;

  DashboardProvider(this._dashboardRepository);

  DashboardStatus _status = DashboardStatus.initial;
  DashboardStats? _stats;
  List<ContinueLearningModel> _continueLearning = [];
  List<RecommendedCourseModel> _recommended = [];
  List<LearningPathProgressModel> _learningPaths = [];
  String? _errorMessage;

  DashboardStatus get status => _status;
  DashboardStats? get stats => _stats;
  List<ContinueLearningModel> get continueLearning => _continueLearning;
  List<RecommendedCourseModel> get recommendedCourses => _recommended;
  List<LearningPathProgressModel> get learningPaths => _learningPaths;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == DashboardStatus.loading;

  Future<void> loadDashboard() async {
    _status = DashboardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadStats(),
        _loadContinueLearning(),
        _loadRecommended(),
      ]);
      _status = DashboardStatus.loaded;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      _status = DashboardStatus.error;
    }

    notifyListeners();
  }

  Future<void> _loadStats() async {
    _stats = await _dashboardRepository.getStats();
  }

  Future<void> _loadContinueLearning() async {
    _continueLearning = await _dashboardRepository.getContinueLearning();
  }

  Future<void> _loadRecommended() async {
    _recommended = await _dashboardRepository.getRecommended();
  }

  Future<void> loadLearnDashboard() async {
    try {
      _learningPaths = await _dashboardRepository.getLearnDashboard();
      notifyListeners();
    } catch (e) {
      _learningPaths = [];
    }
  }

  Future<void> loadStats() async {
    try {
      _stats = await _dashboardRepository.getStats();
      notifyListeners();
    } catch (e) {
      // Keep existing stats
    }
  }

  Future<void> refresh() async {
    await loadDashboard();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
