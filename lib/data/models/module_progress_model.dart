class ModuleProgressModel {
  final int id;
  final int userId;
  final int moduleId;
  final int courseId;
  final bool isCompleted;
  final int? progressPercent;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int? lastPosition;

  ModuleProgressModel({
    required this.id,
    required this.userId,
    required this.moduleId,
    required this.courseId,
    this.isCompleted = false,
    this.progressPercent,
    this.startedAt,
    this.completedAt,
    this.lastPosition,
  });

  factory ModuleProgressModel.fromJson(Map<String, dynamic> json) {
    return ModuleProgressModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? json['userId'] ?? 0,
      moduleId: json['module_id'] ?? json['moduleId'] ?? 0,
      courseId: json['course_id'] ?? json['courseId'] ?? 0,
      isCompleted: json['is_completed'] ?? json['isCompleted'] ?? false,
      progressPercent: json['progress_percent'] ?? json['progressPercent'],
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
      lastPosition: json['last_position'] ?? json['lastPosition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'module_id': moduleId,
      'course_id': courseId,
      'is_completed': isCompleted,
      'progress_percent': progressPercent,
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'last_position': lastPosition,
    };
  }

  String get statusText {
    if (isCompleted) return 'Selesai';
    if (progressPercent != null && progressPercent! > 0) {
      return 'Sedang Belajar';
    }
    return 'Belum Mulai';
  }
}
