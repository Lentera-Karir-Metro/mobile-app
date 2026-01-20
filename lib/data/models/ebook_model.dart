class EbookModel {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final String? author;
  final String? coverImage;
  final String? fileUrl;
  final String? fileFormat;
  final int? fileSize;
  final int? totalPages;
  final String? courseTitle;
  final String? courseThumbnail;
  final int? sequenceOrder;
  final DateTime? createdAt;

  EbookModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    this.author,
    this.coverImage,
    this.fileUrl,
    this.fileFormat,
    this.fileSize,
    this.totalPages,
    this.courseTitle,
    this.courseThumbnail,
    this.sequenceOrder,
    this.createdAt,
  });

  factory EbookModel.fromJson(Map<String, dynamic> json) {
    return EbookModel(
      id: json['id']?.toString() ?? '',
      courseId: json['course_id']?.toString() ?? json['courseId']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      author: json['author'],
      coverImage:
          json['cover_image'] ?? json['coverImage'] ?? json['thumbnail'] ?? json['course_thumbnail'],
      fileUrl: json['file_url'] ?? json['fileUrl'] ?? json['ebook_url'],
      fileFormat: json['file_format'] ?? json['fileFormat'] ?? 'pdf',
      fileSize: _parseIntSafe(json['file_size'] ?? json['fileSize']),
      totalPages: _parseIntSafe(json['total_pages'] ?? json['totalPages']),
      courseTitle: json['course_title'],
      courseThumbnail: json['course_thumbnail'],
      sequenceOrder: _parseIntSafe(json['sequence_order']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null),
    );
  }

  static int? _parseIntSafe(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'author': author,
      'cover_image': coverImage,
      'file_url': fileUrl,
      'file_format': fileFormat,
      'file_size': fileSize,
      'total_pages': totalPages,
      'course_title': courseTitle,
      'course_thumbnail': courseThumbnail,
      'sequence_order': sequenceOrder,
    };
  }

  String get fileSizeFormatted {
    if (fileSize == null) return '-';
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get fileFormatDisplay {
    return fileFormat?.toUpperCase() ?? 'PDF';
  }

  bool get hasFile => fileUrl != null && fileUrl!.isNotEmpty;
  
  // Getter alias for screen compatibility
  String? get coverUrl => coverImage;
}
