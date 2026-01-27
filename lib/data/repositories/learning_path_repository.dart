import 'package:lentera_karir/data/models/learning_path_model.dart';
import 'package:lentera_karir/data/services/learning_path_service.dart';

abstract class LearningPathRepository {
  Future<List<LearningPathModel>> getLearningPaths();
  Future<LearningPathModel?> getLearningPathDetail(String pathId);
  Future<LearningPathModel?> getLearningPathContent(String pathId);
  Future<List<LearningPathEnrollmentModel>> getMyLearningPaths();
}

class LearningPathRepositoryImpl implements LearningPathRepository {
  final LearningPathService _learningPathService;

  LearningPathRepositoryImpl(this._learningPathService);

  @override
  Future<List<LearningPathModel>> getLearningPaths() async {
    try {
      final response = await _learningPathService.getLearningPaths();
      if (response['success'] == true && response['data'] != null) {
        // Backend returns { data: [...], pagination: {...} } wrapped by ApiService as
        // { success: true, data: { data: [...], pagination: {...} } }
        final responseData = response['data'];
        
        // Handle both direct list and nested object structure
        List data = [];
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map) {
          data = (responseData['data'] as List? ?? []);
        }
        
        return data.map((e) => LearningPathModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Error logged - removed print for production
    }
    return [];
  }

  @override
  Future<LearningPathModel?> getLearningPathDetail(String pathId) async {
    try {
      final response = await _learningPathService.getLearningPathDetail(pathId);
      if (response['success'] == true && response['data'] != null) {
        // Backend returns object directly (not wrapped in {data: ...})
        // ApiService wraps it as { success: true, data: <object> }
        return LearningPathModel.fromJson(response['data'] as Map<String, dynamic>);
      }
    } catch (_) {
      // Error logged - removed print for production
    }
    return null;
  }

  @override
  Future<LearningPathModel?> getLearningPathContent(String pathId) async {
    try {
      // Use authenticated endpoint that returns progress data
      final response = await _learningPathService.getLearningPathContent(pathId);
      if (response['success'] == true && response['data'] != null) {
        return LearningPathModel.fromJson(response['data'] as Map<String, dynamic>);
      }
    } catch (_) {
      // Error logged - removed print for production
    }
    return null;
  }

  @override
  Future<List<LearningPathEnrollmentModel>> getMyLearningPaths() async {
    try {
      final response = await _learningPathService.getMyLearningPaths();
      if (response['success'] == true && response['data'] != null) {
        final responseData = response['data'];
        
        // Handle multiple possible structures
        List data = [];
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map) {
          data = responseData['learning_paths'] as List? ?? 
                 responseData['data'] as List? ?? 
                 [];
        }
        
        return data.map((e) => LearningPathEnrollmentModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Error logged - removed print for production
    }
    return [];
  }
}
