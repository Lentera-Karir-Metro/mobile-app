import 'package:lentera_karir/data/api/api_service.dart';
import 'package:lentera_karir/data/api/endpoints.dart';

class LearningPathService {
  final ApiService _apiService;

  LearningPathService(this._apiService);

  // Get public learning paths (catalog)
  Future<Map<String, dynamic>> getLearningPaths() async {
    return await _apiService.get(
      ApiEndpoints.catalogLearningPaths,
      requiresAuth: false,
    );
  }

  // Get learning path detail (catalog/public)
  Future<Map<String, dynamic>> getLearningPathDetail(String pathId) async {
    return await _apiService.get(
      ApiEndpoints.catalogLearningPathDetail(pathId),
      requiresAuth: false,
    );
  }

  // Get my enrolled learning paths with progress (requires auth)
  Future<Map<String, dynamic>> getMyLearningPaths() async {
    return await _apiService.get(ApiEndpoints.learnDashboard);
  }

  // Get learning path content with progress (requires auth)
  Future<Map<String, dynamic>> getLearningPathContent(String lpId) async {
    return await _apiService.get(ApiEndpoints.learningPathContent(lpId));
  }
}
