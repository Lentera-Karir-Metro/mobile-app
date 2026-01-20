import 'package:lentera_karir/data/models/course_model.dart';
import 'package:lentera_karir/data/models/course_enrollment_model.dart';
import 'package:lentera_karir/data/models/ebook_model.dart';
import 'package:lentera_karir/data/services/course_service.dart';

abstract class CourseRepository {
  Future<List<CourseEnrollmentModel>> getMyCourses();
  Future<CourseModel?> getCourseContent(String courseId);
  Future<bool> completeModule(String moduleId);
  Future<List<EbookModel>> getMyEbooks();
}

class CourseRepositoryImpl implements CourseRepository {
  final CourseService _courseService;

  CourseRepositoryImpl(this._courseService);

  @override
  Future<List<CourseEnrollmentModel>> getMyCourses() async {
    try {
      final response = await _courseService.getMyCourses();
      
      // ApiService wraps all responses: {success: true, data: <originalResponse>}
      // Backend /learn/my-courses returns ARRAY directly, so data will be the array
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        
        List list = [];
        if (data is List) {
          // Backend returns array directly - this is the main case
          list = data;
        } else if (data is Map) {
          // In case backend wraps in object
          list = data['courses'] as List? ?? data['data'] as List? ?? [];
        }
        
        return list.map((e) => CourseEnrollmentModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      print('Error getting my courses: $e');
    }
    return [];
  }

  @override
  Future<CourseModel?> getCourseContent(String courseId) async {
    try {
      final response = await _courseService.getCourseContent(courseId);
      if (response['success'] == true && response['data'] != null) {
        return CourseModel.fromJson(response['data']);
      }
    } catch (e) {
      print('Error getting course content: $e');
    }
    return null;
  }

  @override
  Future<bool> completeModule(String moduleId) async {
    try {
      final response = await _courseService.completeModule(moduleId);
      return response['success'] == true;
    } catch (e) {
      print('Error completing module: $e');
      return false;
    }
  }

  @override
  Future<List<EbookModel>> getMyEbooks() async {
    try {
      final response = await _courseService.getMyEbooks();
      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        List list = [];
        if (data is List) {
          list = data;
        } else if (data is Map) {
          list = data['ebooks'] as List? ?? data['data'] as List? ?? [];
        }
        return list.map((e) => EbookModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      print('Error getting my ebooks: $e');
    }
    return [];
  }
}
