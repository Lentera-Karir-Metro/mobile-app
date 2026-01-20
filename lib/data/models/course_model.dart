import 'package:lentera_karir/data/models/module_model.dart';

class CourseModel {
  final String id;
  final String title;
  final String? description;
  final String? thumbnail;
  final String? instructor;
  final double price;
  final double? discountPrice;
  final int totalModules;
  final int totalDuration;
  final String? level;
  final String? category;
  final double? rating;
  final int? reviewCount;
  final bool isPurchased;
  final bool isCompleted; // Course completion status from backend
  final int? progressPercent;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? videoCount;
  final int? ebookCount;
  final List<ModuleModel> modules;
  final MentorInfo? mentor;

  CourseModel({
    required this.id,
    required this.title,
    this.description,
    this.thumbnail,
    this.instructor,
    this.price = 0,
    this.discountPrice,
    this.totalModules = 0,
    this.totalDuration = 0,
    this.level,
    this.category,
    this.rating,
    this.reviewCount,
    this.isPurchased = false,
    this.isCompleted = false,
    this.progressPercent,
    this.createdAt,
    this.updatedAt,
    this.videoCount,
    this.ebookCount,
    this.modules = const [],
    this.mentor,
  });

  // Getters for screen compatibility
  String? get thumbnailUrl => thumbnail;
  
  // Get completed modules count
  int get completedModulesCount => modules.where((m) => m.isCompleted).length;
  
  // Get video modules only
  List<ModuleModel> get videoModules => modules.where((m) => m.type == 'video').toList();
  
  // Get ebook modules only
  List<ModuleModel> get ebookModules => modules.where((m) => m.type == 'ebook').toList();
  
  // Get quiz modules only
  List<ModuleModel> get quizModules => modules.where((m) => m.type == 'quiz').toList();

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    // Handle nested courses structure from getCourseContent API
    List<ModuleModel> parsedModules = [];
    
    // Check if response has 'courses' array (from getCourseContent)
    if (json['courses'] != null && json['courses'] is List && (json['courses'] as List).isNotEmpty) {
      final courseData = (json['courses'] as List).first;
      if (courseData['modules'] != null) {
        parsedModules = (courseData['modules'] as List)
            .map((m) => ModuleModel.fromJson(m))
            .toList();
      }
    }
    // Otherwise check direct 'modules' field
    else if (json['modules'] != null && json['modules'] is List) {
      parsedModules = (json['modules'] as List)
          .map((m) => ModuleModel.fromJson(m))
          .toList();
    }
    
    // Parse mentor info - backend returns mentor_name, mentor_title, mentor_photo_profile
    // directly on the course object (not nested in 'mentor')
    MentorInfo? mentorInfo;
    if (json['mentor'] != null && json['mentor'] is Map) {
      mentorInfo = MentorInfo.fromJson(json['mentor']);
    } else if (json['mentor_name'] != null) {
      // Backend returns mentor fields directly on course
      mentorInfo = MentorInfo(
        name: json['mentor_name'] ?? '',
        jobTitle: json['mentor_title'],
        avatarUrl: json['mentor_photo_profile'],
      );
    }
    
    return CourseModel(
      id: json['id']?.toString() ?? json['course_id']?.toString() ?? '0',
      title: json['title'] ?? '',
      description: json['description'],
      thumbnail: json['thumbnail'] ?? json['thumbnail_url'] ?? json['image'],
      instructor: json['instructor'] ?? json['instructor_name'] ?? json['mentor']?['name'],
      price: _parseDouble(json['price']),
      discountPrice: _parseDouble(json['discount_price'] ?? json['discount_amount']),
      totalModules: _parseInt(json['total_modules'] ?? json['totalModules']) ?? parsedModules.length,
      totalDuration: _parseInt(json['total_duration'] ?? json['totalDuration']) ?? 0,
      level: json['level'],
      category: json['category'] ?? json['category_name'],
      rating: _parseDouble(json['rating']),
      reviewCount: _parseInt(json['review_count'] ?? json['reviewCount']),
      isPurchased: json['is_purchased'] ?? json['isPurchased'] ?? false,
      isCompleted: json['is_completed'] ?? json['isCompleted'] ?? false,
      progressPercent: _parseInt(json['progress_percent'] ?? json['progressPercent']),
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.tryParse(json['created_at'] ?? json['createdAt'] ?? '')
          : null,
      updatedAt: json['updated_at'] != null || json['updatedAt'] != null
          ? DateTime.tryParse(json['updated_at'] ?? json['updatedAt'] ?? '')
          : null,
      videoCount: _parseInt(json['video_count'] ?? json['videoCount'] ?? json['total_modules']),
      ebookCount: _parseInt(json['ebook_count'] ?? json['ebookCount']),
      modules: parsedModules,
      mentor: mentorInfo,
    );
  }

  // Helper method to safely parse double from dynamic value
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

  // Helper method to safely parse int from dynamic value
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) {
      if (value.isNaN || value.isInfinite) return null;
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'instructor': instructor,
      'price': price,
      'discount_price': discountPrice,
      'total_modules': totalModules,
      'total_duration': totalDuration,
      'level': level,
      'category': category,
      'rating': rating,
      'review_count': reviewCount,
      'is_purchased': isPurchased,
      'progress_percent': progressPercent,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'video_count': videoCount,
      'ebook_count': ebookCount,
      'modules': modules.map((m) => m.toJson()).toList(),
      'mentor': mentor?.toJson(),
    };
  }

  String get formattedPrice {
    // If there's a discount, show final price (price - discount)
    final finalPrice = this.finalPrice;
    if (finalPrice == 0) return 'Gratis';
    return 'Rp ${finalPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  String get formattedOriginalPrice {
    if (price == 0) return 'Gratis';
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  double get finalPrice {
    if (discountPrice != null && discountPrice! > 0) {
      return price - discountPrice!;
    }
    return price;
  }

  bool get hasDiscount => discountPrice != null && discountPrice! > 0;

  String get formattedDuration {
    if (totalDuration < 60) return '$totalDuration menit';
    final hours = totalDuration ~/ 60;
    final minutes = totalDuration % 60;
    if (minutes == 0) return '$hours jam';
    return '$hours jam $minutes menit';
  }
}

/// Mentor info class for course instructor details
class MentorInfo {
  final String name;
  final String? jobTitle;
  final String? avatarUrl;

  MentorInfo({
    required this.name,
    this.jobTitle,
    this.avatarUrl,
  });

  factory MentorInfo.fromJson(Map<String, dynamic> json) {
    return MentorInfo(
      name: json['name'] ?? '',
      jobTitle: json['job_title'] ?? json['jobTitle'],
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'job_title': jobTitle,
      'avatar_url': avatarUrl,
    };
  }
}
