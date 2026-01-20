import 'package:lentera_karir/data/models/course_model.dart';

class CourseEnrollmentModel {
  final String id;  // Course ID (from flat structure) or enrollment ID
  final String? oderId;
  final String courseId;  // Course ID
  final CourseModel? course;
  final int progressPercent;
  final String status;
  final DateTime? enrolledAt;
  final DateTime? completedAt;
  final int completedModules;
  final int totalModules;
  
  // Direct fields from flat backend response
  final String? _title;
  final String? _thumbnailUrl;
  final String? _description;

  CourseEnrollmentModel({
    required this.id,
    this.oderId,
    required this.courseId,
    this.course,
    this.progressPercent = 0,
    this.status = 'in_progress',
    this.enrolledAt,
    this.completedAt,
    this.completedModules = 0,
    this.totalModules = 0,
    String? title,
    String? thumbnailUrl,
    String? description,
  }) : _title = title,
       _thumbnailUrl = thumbnailUrl,
       _description = description;

  // Helper method to safely parse int
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) {
      if (value.isNaN || value.isInfinite) return 0;
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  factory CourseEnrollmentModel.fromJson(Map<String, dynamic> json) {
    // Backend /learn/my-courses returns flat structure:
    // { id, title, description, thumbnail_url, progress_percent, ... }
    // NOT nested course object
    
    // Check if this is flat structure (has 'title' at root level)
    final isFlatStructure = json['title'] != null && json['course'] == null && json['Course'] == null;
    
    CourseModel? courseModel;
    if (json['course'] != null) {
      courseModel = CourseModel.fromJson(json['course']);
    } else if (json['Course'] != null) {
      courseModel = CourseModel.fromJson(json['Course']);
    }
    
    return CourseEnrollmentModel(
      id: json['id']?.toString() ?? '',
      oderId: json['user_id']?.toString() ?? json['userId']?.toString(),
      // For flat structure, courseId = id; for nested, use course_id field
      courseId: json['course_id']?.toString() ?? json['courseId']?.toString() ?? json['id']?.toString() ?? '',
      course: courseModel,
      progressPercent: _parseInt(json['progress_percent'] ?? json['progressPercent']),
      status: json['status']?.toString() ?? 'in_progress',
      enrolledAt: json['enrolled_at'] != null
          ? DateTime.tryParse(json['enrolled_at'].toString())
          : (json['enrolledAt'] != null ? DateTime.tryParse(json['enrolledAt'].toString()) : null),
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'].toString())
          : (json['completedAt'] != null ? DateTime.tryParse(json['completedAt'].toString()) : null),
      completedModules: _parseInt(json['completed_modules'] ?? json['completedModules']),
      totalModules: _parseInt(json['total_modules'] ?? json['totalModules']),
      // Extract flat structure fields directly
      title: isFlatStructure ? json['title']?.toString() : null,
      thumbnailUrl: isFlatStructure ? (json['thumbnail_url']?.toString() ?? json['thumbnail']?.toString()) : null,
      description: isFlatStructure ? json['description']?.toString() : null,
    );
  }

  bool get isCompleted => status == 'completed' || progressPercent == 100;

  String get statusText {
    switch (status) {
      case 'completed':
        return 'Selesai';
      case 'in_progress':
        return 'Sedang Belajar';
      default:
        return 'Belum Mulai';
    }
  }
  
  // Getters for screen compatibility - prefer direct fields, fallback to nested course
  String? get thumbnailUrl => _thumbnailUrl ?? course?.thumbnailUrl;
  String get title => _title ?? course?.title ?? 'Untitled Course';
  String? get description => _description ?? course?.description;
}
