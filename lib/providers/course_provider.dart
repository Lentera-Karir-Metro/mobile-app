import 'package:flutter/material.dart';
import 'package:lentera_karir/data/models/course_model.dart';
import 'package:lentera_karir/data/models/course_enrollment_model.dart';
import 'package:lentera_karir/data/repositories/course_repository.dart';

enum CourseStatus { initial, loading, loaded, error }

class CourseProvider extends ChangeNotifier {
  final CourseRepository _courseRepository;

  CourseProvider(this._courseRepository);

  CourseStatus _status = CourseStatus.initial;
  List<CourseEnrollmentModel> _myCourses = [];
  CourseModel? _currentCourse;
  String? _errorMessage;

  CourseStatus get status => _status;
  List<CourseEnrollmentModel> get myCourses => _myCourses;
  CourseModel? get currentCourse => _currentCourse;
  CourseModel? get selectedCourse => _currentCourse; // Alias for screen compatibility
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == CourseStatus.loading;

  List<CourseEnrollmentModel> get inProgressCourses =>
      _myCourses.where((c) => !c.isCompleted).toList();

  List<CourseEnrollmentModel> get completedCourses =>
      _myCourses.where((c) => c.isCompleted).toList();

  Future<void> loadMyCourses() async {
    _status = CourseStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _myCourses = await _courseRepository.getMyCourses();
      _status = CourseStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat kelas: $e';
      _status = CourseStatus.error;
    }

    notifyListeners();
  }

  /// Load course detail by ID (alias for loadCourseContent)
  Future<void> loadCourseDetail(String courseId) async {
    await loadCourseContent(courseId);
  }

  Future<void> loadCourseContent(String courseId) async {
    _status = CourseStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentCourse = await _courseRepository.getCourseContent(courseId);
      _status = CourseStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat konten kelas: $e';
      _status = CourseStatus.error;
    }

    notifyListeners();
  }

  Future<bool> completeModule(String moduleId) async {
    final success = await _courseRepository.completeModule(moduleId);
    if (success && _currentCourse != null) {
      await loadCourseContent(_currentCourse!.id.toString());
    }
    return success;
  }

  void clearCurrentCourse() {
    _currentCourse = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
