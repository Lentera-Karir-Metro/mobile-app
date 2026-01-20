import 'package:flutter/material.dart';
import 'package:lentera_karir/data/models/course_model.dart';
import 'package:lentera_karir/data/repositories/catalog_repository.dart';

enum CatalogStatus { initial, loading, loaded, error }

class CatalogProvider extends ChangeNotifier {
  final CatalogRepository _catalogRepository;

  CatalogProvider(this._catalogRepository);

  CatalogStatus _status = CatalogStatus.initial;
  List<CourseModel> _courses = [];
  List<LearningPathModel> _learningPaths = [];
  List<CategoryModel> _categories = [];
  List<CourseModel> _searchResults = [];
  CourseModel? _coursePreview;
  LearningPathModel? _learningPathDetail;
  String? _errorMessage;
  String _selectedCategory = '';
  String _selectedLevel = '';

  CatalogStatus get status => _status;
  List<CourseModel> get courses => _courses;
  List<LearningPathModel> get learningPaths => _learningPaths;
  List<CategoryModel> get categories => _categories;
  List<CourseModel> get searchResults => _searchResults;
  CourseModel? get coursePreview => _coursePreview;
  CourseModel? get selectedCourse => _coursePreview; // Alias for compatibility
  LearningPathModel? get learningPathDetail => _learningPathDetail;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get selectedLevel => _selectedLevel;
  bool get isLoading => _status == CatalogStatus.loading;

  Future<void> loadCourses({String? category, String? level}) async {
    _status = CatalogStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _courses = await _catalogRepository.getCourses(
        category: category,
        level: level,
      );
      _selectedCategory = category ?? '';
      _selectedLevel = level ?? '';
      _status = CatalogStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat kursus: $e';
      _status = CatalogStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadCoursePreview(String courseId) async {
    _status = CatalogStatus.loading;
    notifyListeners();

    try {
      _coursePreview = await _catalogRepository.getCourseDetail(courseId);
      _status = CatalogStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat preview kursus: $e';
      _status = CatalogStatus.error;
    }

    notifyListeners();
  }

  /// Load course detail (alias for loadCoursePreview)
  Future<void> loadCourseDetail(String courseId) async {
    await loadCoursePreview(courseId);
  }

  Future<void> loadLearningPaths() async {
    _status = CatalogStatus.loading;
    notifyListeners();

    try {
      _learningPaths = await _catalogRepository.getLearningPaths();
      _status = CatalogStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat learning paths: $e';
      _status = CatalogStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadLearningPathDetail(String pathId) async {
    _status = CatalogStatus.loading;
    notifyListeners();

    try {
      _learningPathDetail = await _catalogRepository.getLearningPathDetail(
        pathId,
      );
      _status = CatalogStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat detail learning path: $e';
      _status = CatalogStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _catalogRepository.getCategories();
      notifyListeners();
    } catch (e) {
      _categories = [];
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _status = CatalogStatus.loading;
    notifyListeners();

    try {
      // Use getCourses with search functionality - or filter locally
      final allCourses = await _catalogRepository.getCourses();
      _searchResults = allCourses.where((course) {
        final q = query.toLowerCase();
        return course.title.toLowerCase().contains(q) ||
            (course.description?.toLowerCase().contains(q) ?? false);
      }).toList();
      _status = CatalogStatus.loaded;
    } catch (e) {
      _searchResults = [];
      _status = CatalogStatus.error;
    }

    notifyListeners();
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  void clearPreview() {
    _coursePreview = null;
    _learningPathDetail = null;
    notifyListeners();
  }

  void setFilter({String? category, String? level}) {
    _selectedCategory = category ?? _selectedCategory;
    _selectedLevel = level ?? _selectedLevel;
    loadCourses(category: _selectedCategory, level: _selectedLevel);
  }

  void clearFilter() {
    _selectedCategory = '';
    _selectedLevel = '';
    loadCourses();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
