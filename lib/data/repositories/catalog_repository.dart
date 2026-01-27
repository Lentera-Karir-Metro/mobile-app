import 'package:lentera_karir/data/models/course_model.dart';
import 'package:lentera_karir/data/services/catalog_service.dart';

abstract class CatalogRepository {
  Future<List<CourseModel>> getCourses({
    int? page,
    int? limit,
    String? category,
    String? level,
  });
  Future<CourseModel?> getCourseDetail(String courseId);
  Future<List<LearningPathModel>> getLearningPaths();
  Future<LearningPathModel?> getLearningPathDetail(String pathId);
  Future<List<CategoryModel>> getCategories();
  Future<List<MentorModel>> getMentors();
}

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogService _catalogService;

  CatalogRepositoryImpl(this._catalogService);

  /// Helper to check if response indicates server error
  bool _isServerError(Map<String, dynamic> response) {
    final statusCode = response['statusCode'];
    return statusCode != null && (statusCode >= 500 || statusCode == 502);
  }

  @override
  Future<List<CourseModel>> getCourses({
    int? page,
    int? limit,
    String? category,
    String? level,
  }) async {
    try {
      final response = await _catalogService.getCourses(
        page: page,
        limit: limit,
        category: category,
        level: level,
      );
      
      // Check for server error (502, 500, etc)
      if (_isServerError(response)) {
        throw Exception('Server error: ${response['statusCode']}');
      }
      
      if (response['success'] == true && response['data'] != null) {
        // Backend returns { success: true, data: { data: [...], pagination: {...} } }
        final responseData = response['data'];
        
        // Handle both direct list and nested object structure
        List data = [];
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map) {
          data = (responseData['data'] as List? ?? []);
        }
        
        return data.map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      // Error logged - removed print for production
      rethrow;
    }
    return [];
  }

  @override
  Future<CourseModel?> getCourseDetail(String courseId) async {
    try {
      final response = await _catalogService.getCourseDetail(courseId);
      
      // ApiService wraps ALL responses in {success: true, data: <backend_response>}
      // Backend returns: { id, title, description, modules, ... }
      // ApiService returns: { success: true, data: { id, title, ... } }
      if (response['success'] == true && response['data'] != null) {
        return CourseModel.fromJson(response['data']);
      }
    } catch (_) {
      // Error logged - removed print for production
    }
    return null;
  }

  @override
  Future<List<LearningPathModel>> getLearningPaths() async {
    try {
      final response = await _catalogService.getLearningPaths();
      
      // Backend returns { data: [...], pagination: {...} } (no success wrapper)
      List data = [];
      if (response['data'] != null) {
        final responseData = response['data'];
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map) {
          data = (responseData['data'] as List? ?? []);
        }
      }
      
      if (data.isNotEmpty) {
        return data.map((e) => LearningPathModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      // Error logged - removed print for production
    }
    return [];
  }

  @override
  Future<LearningPathModel?> getLearningPathDetail(String pathId) async {
    try {
      final response = await _catalogService.getLearningPathDetail(pathId);
      
      // Backend returns data directly (not wrapped in {success, data})
      // Check if response has 'id' field (LP data) or success/data wrapper
      if (response['id'] != null) {
        // Direct response - LP data returned directly
        return LearningPathModel.fromJson(response);
      } else if (response['success'] == true && response['data'] != null) {
        // Wrapped response
        return LearningPathModel.fromJson(response['data']);
      }
    } catch (e) {
      // Error logged - removed print for production
    }
    return null;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _catalogService.getCategories();
      if (response['success'] == true && response['data'] != null) {
        final responseData = response['data'];
        
        // Handle both direct list and nested object structure
        List data = [];
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map) {
          data = (responseData['data'] as List? ?? []);
        }
        
        return data.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      // Error logged - removed print for production
    }
    return [];
  }

  @override
  Future<List<MentorModel>> getMentors() async {
    try {
      final response = await _catalogService.getMentors();
      if (response['success'] == true && response['data'] != null) {
        final responseData = response['data'];
        
        // Handle both direct list and nested object structure
        List data = [];
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map) {
          data = (responseData['data'] as List? ?? []);
        }
        
        return data.map((e) => MentorModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      // Error logged - removed print for production
    }
    return [];
  }
}

class LearningPathModel {
  final String id;
  final String title;
  final String? description;
  final String? thumbnail;
  final double price;
  final int totalCourses;
  final int totalDuration;
  final List<CourseModel> courses;

  LearningPathModel({
    required this.id,
    required this.title,
    this.description,
    this.thumbnail,
    this.price = 0,
    this.totalCourses = 0,
    this.totalDuration = 0,
    this.courses = const [],
  });

  factory LearningPathModel.fromJson(Map<String, dynamic> json) {
    return LearningPathModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      thumbnail: json['thumbnail'] ?? json['image'],
      price: (json['price'] ?? 0).toDouble(),
      totalCourses: json['course_count'] ?? json['total_courses'] ?? json['totalCourses'] ?? 0,
      totalDuration: json['total_duration'] ?? json['totalDuration'] ?? 0,
      courses: (json['courses'] as List? ?? [])
          .map((e) => CourseModel.fromJson(e))
          .toList(),
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String? icon;
  final int courseCount;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.courseCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      icon: json['icon'],
      courseCount: json['course_count'] ?? json['courseCount'] ?? 0,
    );
  }
}

class MentorModel {
  final String id;
  final String name;
  final String? photo;
  final String? expertise;
  final String? bio;

  MentorModel({
    required this.id,
    required this.name,
    this.photo,
    this.expertise,
    this.bio,
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      photo: json['photo'] ?? json['avatar'],
      expertise: json['expertise'] ?? json['specialization'],
      bio: json['bio'] ?? json['description'],
    );
  }
}
