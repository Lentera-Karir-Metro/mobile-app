class DashboardStats {
  final int totalCourses;
  final int completedCourses;
  final int inProgressCourses;
  final int totalCertificates;
  final int totalEbooks;

  DashboardStats({
    this.totalCourses = 0,
    this.completedCourses = 0,
    this.inProgressCourses = 0,
    this.totalCertificates = 0,
    this.totalEbooks = 0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      // Backend returns: totalKelas, totalEbook, totalSertifikat
      totalCourses: json['totalKelas'] ?? json['total_kelas'] ?? json['total_courses'] ?? json['totalCourses'] ?? 0,
      completedCourses:
          json['completed_courses'] ?? json['completedCourses'] ?? 0,
      inProgressCourses:
          json['in_progress_courses'] ?? json['inProgressCourses'] ?? 0,
      totalCertificates:
          json['totalSertifikat'] ?? json['total_sertifikat'] ?? json['total_certificates'] ?? json['totalCertificates'] ?? 0,
      totalEbooks: json['totalEbook'] ?? json['total_ebook'] ?? json['total_ebooks'] ?? json['totalEbooks'] ?? 0,
    );
  }
}

class ContinueLearningModel {
  final String id;
  final String title;
  final String? thumbnail;
  final int progress;
  final String? lastModuleTitle;
  final DateTime? lastAccessedAt;
  final int totalModules;
  final int completedModules;

  ContinueLearningModel({
    required this.id,
    required this.title,
    this.thumbnail,
    this.progress = 0,
    this.lastModuleTitle,
    this.lastAccessedAt,
    this.totalModules = 0,
    this.completedModules = 0,
  });
  
  // Getter for progress percent
  int get progressPercent => progress;

  factory ContinueLearningModel.fromJson(Map<String, dynamic> json) {
    return ContinueLearningModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['course_title'] ?? '',
      // Backend returns thumbnail_url, fallback to thumbnail/image
      thumbnail: json['thumbnail_url'] ?? json['thumbnail'] ?? json['image'],
      // Backend returns progress_percent
      progress: json['progress_percent'] ?? json['progress'] ?? json['progress_percentage'] ?? 0,
      lastModuleTitle: json['last_module_title'] ?? json['lastModuleTitle'],
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.tryParse(json['last_accessed_at'])
          : null,
      totalModules: json['total_modules'] ?? json['totalModules'] ?? 0,
      completedModules: json['completed_modules'] ?? json['completedModules'] ?? 0,
    );
  }
}

class RecommendedCourseModel {
  final String id;
  final String title;
  final String? thumbnail;
  final String? description;
  final double price;
  final double? discountAmount;
  final String? level;
  final String? category;
  final String? mentorName;
  final String? mentorTitle;
  final String? mentorPhoto;
  final int courseCount; // Number of courses in this learning path

  RecommendedCourseModel({
    required this.id,
    required this.title,
    this.thumbnail,
    this.description,
    this.price = 0,
    this.discountAmount,
    this.level,
    this.category,
    this.mentorName,
    this.mentorTitle,
    this.mentorPhoto,
    this.courseCount = 0,
  });

  factory RecommendedCourseModel.fromJson(Map<String, dynamic> json) {
    return RecommendedCourseModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      // Backend returns thumbnail_url
      thumbnail: json['thumbnail_url'] ?? json['thumbnail'] ?? json['image'],
      description: json['description'],
      price: _parseDouble(json['price']),
      discountAmount: json['discount_amount'] != null ? _parseDouble(json['discount_amount']) : null,
      level: json['level'],
      category: json['category'],
      mentorName: json['mentor_name'] ?? json['mentorName'],
      mentorTitle: json['mentor_title'] ?? json['mentorTitle'],
      mentorPhoto: json['mentor_photo_profile'] ?? json['mentor_photo'],
      courseCount: _parseInt(json['course_count'] ?? json['courseCount'] ?? json['total_courses']),
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

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class LearningPathProgressModel {
  final String id;
  final String title;
  final String? description;
  final String? thumbnail;
  final int progress;
  final int totalCourses;
  final int completedCourses;
  final DateTime? createdAt;

  LearningPathProgressModel({
    required this.id,
    required this.title,
    this.description,
    this.thumbnail,
    this.progress = 0,
    this.totalCourses = 0,
    this.completedCourses = 0,
    this.createdAt,
  });

  factory LearningPathProgressModel.fromJson(Map<String, dynamic> json) {
    return LearningPathProgressModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      thumbnail: json['thumbnail'] ?? json['image'],
      progress: json['progress'] ?? json['progress_percentage'] ?? 0,
      totalCourses: json['total_courses'] ?? json['totalCourses'] ?? 0,
      completedCourses: json['completed_courses'] ?? json['completedCourses'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
