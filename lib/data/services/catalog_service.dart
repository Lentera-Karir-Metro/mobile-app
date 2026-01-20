import 'package:lentera_karir/data/api/api_service.dart';
import 'package:lentera_karir/data/api/endpoints.dart';

class CatalogService {
  final ApiService _apiService;

  CatalogService(this._apiService);

  // Get public courses
  Future<Map<String, dynamic>> getCourses({
    int? page,
    int? limit,
    String? category,
    String? level,
  }) async {
    Map<String, String> queryParams = {};
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (category != null) queryParams['category'] = category;
    if (level != null) queryParams['level'] = level;

    return await _apiService.get(
      ApiEndpoints.catalogCourses,
      requiresAuth: false,
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  // Get course detail
  Future<Map<String, dynamic>> getCourseDetail(String courseId) async {
    return await _apiService.get(
      ApiEndpoints.catalogCourseDetail(courseId),
      requiresAuth: false,
    );
  }

  // Get learning paths
  Future<Map<String, dynamic>> getLearningPaths() async {
    return await _apiService.get(
      ApiEndpoints.catalogLearningPaths,
      requiresAuth: false,
    );
  }

  // Get learning path detail
  Future<Map<String, dynamic>> getLearningPathDetail(String pathId) async {
    return await _apiService.get(
      ApiEndpoints.catalogLearningPathDetail(pathId),
      requiresAuth: false,
    );
  }

  // Get categories
  Future<Map<String, dynamic>> getCategories() async {
    return await _apiService.get(
      ApiEndpoints.catalogCategories,
      requiresAuth: false,
    );
  }

  // Get mentors
  Future<Map<String, dynamic>> getMentors() async {
    return await _apiService.get(
      ApiEndpoints.catalogMentors,
      requiresAuth: false,
    );
  }
}
