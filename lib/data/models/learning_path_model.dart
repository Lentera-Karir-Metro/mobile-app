import 'package:lentera_karir/data/models/course_model.dart';

class LearningPathModel {
  final String id;  // Changed from int to String - backend uses STRING(16) like "LP-xxxxxx"
  final String title;
  final String? description;
  final String? thumbnail;
  final double price;
  final double? discountPrice;
  final int totalCourses;
  final int totalDuration;
  final String? level;
  final bool isPurchased;
  final int? progressPercent;
  final List<CourseModel> courses;
  final DateTime? createdAt;

  LearningPathModel({
    required this.id,
    required this.title,
    this.description,
    this.thumbnail,
    this.price = 0,
    this.discountPrice,
    this.totalCourses = 0,
    this.totalDuration = 0,
    this.level,
    this.isPurchased = false,
    this.progressPercent,
    this.courses = const [],
    this.createdAt,
  });

  factory LearningPathModel.fromJson(Map<String, dynamic> json) {
    // Safe parsing untuk courses field
    List<CourseModel> parsedCourses = [];
    try {
      final coursesData = json['courses'];
      if (coursesData is List) {
        parsedCourses = coursesData
            .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (coursesData is Map && coursesData['data'] is List) {
        // Handle nested structure: { data: [...] }
        parsedCourses = (coursesData['data'] as List)
            .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error parsing courses in learning path: $e');
    }

    return LearningPathModel(
      id: json['id']?.toString() ?? '',  // Handle both int and string IDs
      title: json['title'] ?? '',
      description: json['description'],
      thumbnail: json['thumbnail'] ?? json['image'],
      price: _parseDouble(json['price']),
      discountPrice: _parseDouble(json['discount_price']),
      totalCourses: json['total_courses'] ?? json['totalCourses'] ?? json['course_count'] ?? parsedCourses.length,
      totalDuration: json['total_duration'] ?? json['totalDuration'] ?? 0,
      level: json['level'],
      isPurchased: json['is_purchased'] ?? json['isPurchased'] ?? false,
      progressPercent: json['progress_percent'] ?? json['progressPercent'],
      courses: parsedCourses,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : (json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) {
      if (value.isNaN || value.isInfinite) return 0.0;
      return value;
    }
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value) ?? 0.0;
      if (parsed.isNaN || parsed.isInfinite) return 0.0;
      return parsed;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'price': price,
      'discount_price': discountPrice,
      'total_courses': totalCourses,
      'total_duration': totalDuration,
      'level': level,
      'is_purchased': isPurchased,
      'progress_percent': progressPercent,
    };
  }

  String get formattedPrice {
    if (price == 0) return 'Gratis';
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  String get formattedDuration {
    if (totalDuration < 60) return '$totalDuration menit';
    final hours = totalDuration ~/ 60;
    final minutes = totalDuration % 60;
    if (minutes == 0) return '$hours jam';
    return '$hours jam $minutes menit';
  }
}

class LearningPathEnrollmentModel {
  final String id;  // Changed to String
  final String? oderId;  // Changed to String
  final String learningPathId;  // Changed to String - backend uses STRING(16)
  final LearningPathModel? learningPath;
  final int progressPercent;
  final String status;
  final int completedCourses;
  final int totalCourses;
  final DateTime? enrolledAt;
  final DateTime? completedAt;

  LearningPathEnrollmentModel({
    required this.id,
    this.oderId,
    required this.learningPathId,
    this.learningPath,
    this.progressPercent = 0,
    this.status = 'in_progress',
    this.completedCourses = 0,
    this.totalCourses = 0,
    this.enrolledAt,
    this.completedAt,
  });

  factory LearningPathEnrollmentModel.fromJson(Map<String, dynamic> json) {
    return LearningPathEnrollmentModel(
      id: json['id']?.toString() ?? '',
      oderId: json['user_id']?.toString() ?? json['userId']?.toString(),
      learningPathId: json['learning_path_id']?.toString() ?? json['learningPathId']?.toString() ?? '',
      learningPath: json['learning_path'] != null
          ? LearningPathModel.fromJson(json['learning_path'])
          : (json['LearningPath'] != null 
              ? LearningPathModel.fromJson(json['LearningPath']) 
              : null),
      progressPercent: json['progress_percent'] ?? json['progressPercent'] ?? 0,
      status: json['status'] ?? 'in_progress',
      completedCourses:
          json['completed_courses'] ?? json['completedCourses'] ?? 0,
      totalCourses: json['total_courses'] ?? json['totalCourses'] ?? 0,
      enrolledAt: json['enrolled_at'] != null
          ? DateTime.tryParse(json['enrolled_at'])
          : (json['enrolledAt'] != null ? DateTime.tryParse(json['enrolledAt']) : null),
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : (json['completedAt'] != null ? DateTime.tryParse(json['completedAt']) : null),
    );
  }

  bool get isCompleted => status == 'completed' || progressPercent == 100;
}
