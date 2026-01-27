import 'package:lentera_karir/data/models/dashboard_model.dart';
import 'package:lentera_karir/data/services/dashboard_service.dart';

abstract class DashboardRepository {
  Future<DashboardStats?> getStats();
  Future<List<ContinueLearningModel>> getContinueLearning();
  Future<List<RecommendedCourseModel>> getRecommended();
  Future<List<LearningPathProgressModel>> getLearnDashboard();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardService _dashboardService;

  DashboardRepositoryImpl(this._dashboardService);

  /// Helper to check if response indicates server error
  bool _isServerError(Map<String, dynamic> response) {
    final statusCode = response['statusCode'];
    return statusCode != null && (statusCode >= 500 || statusCode == 502);
  }

  @override
  Future<DashboardStats?> getStats() async {
    try {
      final response = await _dashboardService.getStats();
      
      // Check for server error (502, 500, etc)
      if (_isServerError(response)) {
        throw Exception('Server error: ${response['statusCode']}');
      }
      
      if (response['success'] == true && response['data'] != null) {
        return DashboardStats.fromJson(response['data']);
      }
    } catch (e) {
      // debugPrint removed for production
      rethrow; // Re-throw to let provider handle it
    }
    return null;
  }

  @override
  Future<List<ContinueLearningModel>> getContinueLearning() async {
    try {
      final response = await _dashboardService.getContinueLearning();
      
      // Check for server error
      if (_isServerError(response)) {
        throw Exception('Server error: ${response['statusCode']}');
      }
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        // Backend returns single object, not array
        // Wrap in list if it's a single object
        if (data is List) {
          return data.map((e) => ContinueLearningModel.fromJson(e as Map<String, dynamic>)).toList();
        } else if (data is Map<String, dynamic>) {
          return [ContinueLearningModel.fromJson(data)];
        }
      }
    } catch (e) {
      // debugPrint removed for production
      rethrow;
    }
    return [];
  }

  @override
  Future<List<RecommendedCourseModel>> getRecommended() async {
    try {
      final response = await _dashboardService.getRecommended();
      
      // Check for server error
      if (_isServerError(response)) {
        throw Exception('Server error: ${response['statusCode']}');
      }
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        // Handle both direct list and nested object structure
        List list = [];
        if (data is List) {
          list = data;
        } else if (data is Map) {
          list = data['data'] as List? ?? [];
        }
        return list.map((e) => RecommendedCourseModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      // debugPrint removed for production
      rethrow;
    }
    return [];
  }

  @override
  Future<List<LearningPathProgressModel>> getLearnDashboard() async {
    try {
      final response = await _dashboardService.getLearnDashboard();
      
      // Check for server error
      if (_isServerError(response)) {
        throw Exception('Server error: ${response['statusCode']}');
      }
      
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        // Handle both direct list and nested object structure
        List list = [];
        if (data is List) {
          list = data;
        } else if (data is Map) {
          list = data['learning_paths'] as List? ?? data['data'] as List? ?? [];
        }
        return list.map((e) => LearningPathProgressModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      // debugPrint removed for production
      rethrow;
    }
    return [];
  }
}
