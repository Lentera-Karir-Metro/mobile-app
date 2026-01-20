import 'package:lentera_karir/data/api/api_service.dart';
import 'package:lentera_karir/data/api/endpoints.dart';

class CertificateService {
  final ApiService _apiService;

  CertificateService(this._apiService);

  // Get all user certificates
  Future<Map<String, dynamic>> getCertificates() async {
    return await _apiService.get(ApiEndpoints.certificates);
  }

  // Get certificate detail by ID
  Future<Map<String, dynamic>> getCertificateDetail(String certificateId) async {
    return await _apiService.get(
      ApiEndpoints.certificateDetail(certificateId),
    );
  }

  // Get certificate status for a course
  Future<Map<String, dynamic>> getCertificateStatus(String courseId) async {
    return await _apiService.get(
      ApiEndpoints.certificateStatus(courseId),
    );
  }

  // Check course completion (user-certificates endpoint)
  Future<Map<String, dynamic>> checkCourseCompletion(String courseId) async {
    return await _apiService.get(
      ApiEndpoints.checkCourseCompletion(courseId),
    );
  }

  // Get available certificate templates
  Future<Map<String, dynamic>> getTemplates() async {
    return await _apiService.get(ApiEndpoints.certificateTemplates);
  }

  // Preview certificate before generating
  Future<Map<String, dynamic>> previewCertificate({
    required String courseId,
    required String templateId,
  }) async {
    return await _apiService.post(
      ApiEndpoints.previewCertificate,
      body: {
        'course_id': courseId,
        'template_id': templateId,
      },
    );
  }

  // Generate certificate with selected template
  Future<Map<String, dynamic>> generateCertificate({
    required String courseId,
    required String templateId,
  }) async {
    return await _apiService.post(
      ApiEndpoints.generateCertificate,
      body: {
        'course_id': courseId,
        'template_id': templateId,
      },
    );
  }
}
