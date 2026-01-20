import 'package:lentera_karir/data/api/api_service.dart';
import 'package:lentera_karir/data/api/endpoints.dart';

class CourseService {
  final ApiService _apiService;

  CourseService(this._apiService);

  // Get my enrolled courses
  Future<Map<String, dynamic>> getMyCourses() async {
    return await _apiService.get(ApiEndpoints.myCourses);
  }

  // Get course content/detail (includes modules and progress)
  Future<Map<String, dynamic>> getCourseContent(String courseId) async {
    return await _apiService.get(ApiEndpoints.courseContent(courseId));
  }

  // Mark module as complete (POST)
  Future<Map<String, dynamic>> completeModule(String moduleId) async {
    return await _apiService.post(
      ApiEndpoints.completeModule(moduleId),
      body: {},
    );
  }

  // Get my ebooks from all enrolled courses
  Future<Map<String, dynamic>> getMyEbooks() async {
    return await _apiService.get(ApiEndpoints.myEbooks);
  }
}
