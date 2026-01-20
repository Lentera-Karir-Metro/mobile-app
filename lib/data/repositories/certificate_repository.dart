import 'package:lentera_karir/data/models/certificate_model.dart';
import 'package:lentera_karir/data/services/certificate_service.dart';

abstract class CertificateRepository {
  Future<List<CertificateModel>> getCertificates();
  Future<CertificateModel?> getCertificateDetail(String certificateId);
  Future<CertificateStatusModel?> getCertificateStatus(String courseId);
  Future<CourseCompletionModel?> checkCourseCompletion(String courseId);
  Future<List<CertificateTemplateModel>> getTemplates();
  Future<CertificatePreviewModel?> previewCertificate(String courseId, String templateId);
  Future<CertificateModel?> generateCertificate(String courseId, String templateId);
}

class CertificateRepositoryImpl implements CertificateRepository {
  final CertificateService _certificateService;

  CertificateRepositoryImpl(this._certificateService);

  @override
  Future<List<CertificateModel>> getCertificates() async {
    final response = await _certificateService.getCertificates();
    if (response['success'] == true && response['data'] != null) {
      final data = response['data'];
      // Backend returns data as array directly
      if (data is List) {
        return data.map((e) => CertificateModel.fromJson(e as Map<String, dynamic>)).toList();
      } else if (data is Map && data['certificates'] != null) {
        final List certificates = data['certificates'];
        return certificates.map((e) => CertificateModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    }
    return [];
  }

  @override
  Future<CertificateModel?> getCertificateDetail(String certificateId) async {
    final response = await _certificateService.getCertificateDetail(certificateId);
    if (response['success'] == true && response['data'] != null) {
      return CertificateModel.fromJson(response['data']);
    }
    return null;
  }

  @override
  Future<CertificateStatusModel?> getCertificateStatus(String courseId) async {
    final response = await _certificateService.getCertificateStatus(courseId);
    if (response['success'] == true && response['data'] != null) {
      return CertificateStatusModel.fromJson(response['data']);
    }
    return null;
  }

  @override
  Future<CourseCompletionModel?> checkCourseCompletion(String courseId) async {
    final response = await _certificateService.checkCourseCompletion(courseId);
    if (response['success'] == true && response['data'] != null) {
      return CourseCompletionModel.fromJson(response['data']);
    }
    return null;
  }

  @override
  Future<List<CertificateTemplateModel>> getTemplates() async {
    final response = await _certificateService.getTemplates();
    if (response['success'] == true && response['data'] != null) {
      final List templates = response['data'] is List
          ? response['data']
          : response['data']['templates'] ?? [];
      return templates.map((e) => CertificateTemplateModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<CertificatePreviewModel?> previewCertificate(
    String courseId,
    String templateId,
  ) async {
    final response = await _certificateService.previewCertificate(
      courseId: courseId,
      templateId: templateId,
    );
    if (response['success'] == true && response['data'] != null) {
      return CertificatePreviewModel.fromJson(response['data']);
    }
    return null;
  }

  @override
  Future<CertificateModel?> generateCertificate(
    String courseId,
    String templateId,
  ) async {
    final response = await _certificateService.generateCertificate(
      courseId: courseId,
      templateId: templateId,
    );
    if (response['success'] == true && response['data'] != null) {
      return CertificateModel.fromJson(response['data']);
    }
    return null;
  }
}
