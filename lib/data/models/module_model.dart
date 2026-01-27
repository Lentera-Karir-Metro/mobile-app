class ModuleModel {
  final String id; // Changed to String - backend returns "MD-xxxxxx"
  final String courseId; // Changed to String - backend returns "CR-xxxxxx"
  final String title;
  final String? description;
  final String? content;
  final String? videoUrl;
  final String? ebookUrl;
  final int duration;
  final int orderIndex;
  final bool isLocked;
  final bool isCompleted;
  final bool? isPassed; // For quiz modules
  final bool hasQuiz;
  final String? quizId; // Backend returns "QZ-xxxxxx"
  final String type; // 'video', 'ebook', 'quiz'

  ModuleModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    this.content,
    this.videoUrl,
    this.ebookUrl,
    this.duration = 0,
    this.orderIndex = 0,
    this.isLocked = false,
    this.isCompleted = false,
    this.isPassed,
    this.hasQuiz = false,
    this.quizId,
    this.type = 'video',
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    // Parse module_id as String (backend returns "MD-xxxxxx" format)
    final moduleId = (json['module_id'] ?? json['id'])?.toString() ?? '';
    final parsedCourseId = (json['course_id'] ?? json['courseId'])?.toString() ?? '';
    
    return ModuleModel(
      id: moduleId,
      courseId: parsedCourseId,
      title: json['title'] ?? '',
      description: json['description'],
      content: json['content'],
      videoUrl: json['video_url'] ?? json['videoUrl'],
      ebookUrl: json['ebook_url'] ?? json['ebookUrl'],
      duration: _parseInt(json['duration']) ?? 0,
      orderIndex: _parseInt(json['order_index'] ?? json['orderIndex'] ?? json['sequence_order']) ?? 0,
      isLocked: json['is_locked'] ?? json['isLocked'] ?? false,
      isCompleted: json['is_completed'] ?? json['isCompleted'] ?? false,
      isPassed: json['is_passed'] ?? json['isPassed'],
      hasQuiz: json['has_quiz'] ?? json['hasQuiz'] ?? (json['quiz_id'] != null),
      quizId: json['quiz_id']?.toString() ?? json['quizId']?.toString(),
      type: json['type'] ?? _inferType(json),
    );
  }

  /// Helper to safely parse int from dynamic (String/int/double)
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) {
      if (value.isNaN || value.isInfinite) return null;
      return value.toInt();
    }
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Infer module type from available fields
  static String _inferType(Map<String, dynamic> json) {
    if (json['video_url'] != null || json['videoUrl'] != null) return 'video';
    if (json['ebook_url'] != null || json['ebookUrl'] != null) return 'ebook';
    if (json['quiz_id'] != null || json['quizId'] != null) return 'quiz';
    return 'video';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'content': content,
      'video_url': videoUrl,
      'ebook_url': ebookUrl,
      'duration': duration,
      'order_index': orderIndex,
      'is_locked': isLocked,
      'is_completed': isCompleted,
      'is_passed': isPassed,
      'has_quiz': hasQuiz,
      'quiz_id': quizId,
      'type': type,
    };
  }

  String get formattedDuration {
    if (duration < 60) return '$duration menit';
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (minutes == 0) return '$hours jam';
    return '$hours jam $minutes menit';
  }
  
  /// Check if this is a video module
  bool get isVideo => type == 'video';
  
  /// Check if this is an ebook module
  bool get isEbook => type == 'ebook';
  
  /// Check if this is a quiz module
  bool get isQuiz => type == 'quiz';
}
