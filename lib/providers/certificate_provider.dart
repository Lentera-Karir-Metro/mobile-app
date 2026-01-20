import 'package:flutter/material.dart';
import 'package:lentera_karir/data/models/certificate_model.dart';
import 'package:lentera_karir/data/repositories/certificate_repository.dart';

enum CertificateStatus {
  initial,
  loading,
  loaded,
  requesting,
  requested,
  error,
}

class CertificateProvider extends ChangeNotifier {
  final CertificateRepository _certificateRepository;

  CertificateProvider(this._certificateRepository);

  CertificateStatus _status = CertificateStatus.initial;
  List<CertificateModel> _certificates = [];
  CertificateModel? _selectedCertificate;
  CertificateStatusModel? _certificateStatus;
  CourseCompletionModel? _completion;
  List<CertificateTemplateModel> _templates = [];
  CertificatePreviewModel? _preview;
  String? _errorMessage;

  CertificateStatus get status => _status;
  List<CertificateModel> get certificates => _certificates;
  CertificateModel? get selectedCertificate => _selectedCertificate;
  CertificateStatusModel? get certificateStatus => _certificateStatus;
  CourseCompletionModel? get completion => _completion;
  List<CertificateTemplateModel> get templates => _templates;
  CertificatePreviewModel? get preview => _preview;
  String? get errorMessage => _errorMessage;
  bool get isLoading =>
      _status == CertificateStatus.loading ||
      _status == CertificateStatus.requesting;

  Future<void> loadCertificates() async {
    _status = CertificateStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _certificates = await _certificateRepository.getCertificates();
      _status = CertificateStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat sertifikat: $e';
      _status = CertificateStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadCertificateDetail(String certificateId) async {
    _status = CertificateStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedCertificate = await _certificateRepository.getCertificateDetail(
        certificateId,
      );
      _status = CertificateStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat detail sertifikat: $e';
      _status = CertificateStatus.error;
    }

    notifyListeners();
  }

  Future<void> checkCourseCompletion(String courseId) async {
    _status = CertificateStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _completion = await _certificateRepository.checkCourseCompletion(courseId);
      _status = CertificateStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal mengecek kelayakan sertifikat: $e';
      _status = CertificateStatus.error;
    }

    notifyListeners();
  }

  Future<void> getCertificateStatus(String courseId) async {
    _status = CertificateStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _certificateStatus = await _certificateRepository.getCertificateStatus(courseId);
      _status = CertificateStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat status sertifikat: $e';
      _status = CertificateStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadTemplates() async {
    try {
      _templates = await _certificateRepository.getTemplates();
      notifyListeners();
    } catch (e) {
      _templates = [];
    }
  }

  Future<void> previewCertificate(String courseId, String templateId) async {
    _status = CertificateStatus.loading;
    notifyListeners();

    try {
      _preview = await _certificateRepository.previewCertificate(courseId, templateId);
      _status = CertificateStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal membuat preview sertifikat: $e';
      _status = CertificateStatus.error;
    }

    notifyListeners();
  }

  Future<CertificateModel?> generateCertificate(String courseId, String templateId) async {
    _status = CertificateStatus.requesting;
    _errorMessage = null;
    notifyListeners();

    try {
      final certificate = await _certificateRepository.generateCertificate(
        courseId,
        templateId,
      );
      if (certificate != null) {
        _selectedCertificate = certificate;
        _certificates.add(certificate);
        _status = CertificateStatus.requested;
      } else {
        _errorMessage = 'Gagal membuat sertifikat';
        _status = CertificateStatus.error;
      }
      notifyListeners();
      return certificate;
    } catch (e) {
      _errorMessage = 'Gagal membuat sertifikat: $e';
      _status = CertificateStatus.error;
      notifyListeners();
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSelected() {
    _selectedCertificate = null;
    _certificateStatus = null;
    _completion = null;
    _preview = null;
    notifyListeners();
  }
}
