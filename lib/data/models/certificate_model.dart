class CertificateModel {
  final String id;
  final String? oderId;
  final String? courseId;
  final String courseName;
  final String certificateNumber;
  final String? certificateUrl;
  final String? courseThumbnail; // Course thumbnail for display
  final String status;
  final DateTime? issuedAt;
  final DateTime? expiredAt;
  final DateTime createdAt;

  CertificateModel({
    required this.id,
    this.oderId,
    this.courseId,
    required this.courseName,
    required this.certificateNumber,
    this.certificateUrl,
    this.courseThumbnail,
    this.status = 'pending',
    this.issuedAt,
    this.expiredAt,
    required this.createdAt,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    // Handle nested Course object from backend
    final course = json['Course'] as Map<String, dynamic>?;
    
    return CertificateModel(
      id: json['id']?.toString() ?? '',
      oderId: json['user_id']?.toString() ?? json['userId']?.toString(),
      courseId: json['course_id']?.toString() ?? json['courseId']?.toString() ?? course?['id']?.toString(),
      courseName:
          json['course_name'] ??
          json['courseName'] ??
          json['course_title'] ??
          course?['title'] ??
          '',
      certificateNumber:
          json['certificate_number'] ?? json['certificateNumber'] ?? '',
      certificateUrl: json['certificate_url'] ?? json['certificateUrl'],
      courseThumbnail: course?['thumbnail_url'] ?? json['course_thumbnail'] ?? json['thumbnail_url'],
      status: json['status'] ?? 'pending',
      issuedAt: json['issued_at'] != null
          ? DateTime.tryParse(json['issued_at'])
          : null,
      expiredAt: json['expired_at'] != null
          ? DateTime.tryParse(json['expired_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': oderId,
      'course_id': courseId,
      'course_name': courseName,
      'certificate_number': certificateNumber,
      'certificate_url': certificateUrl,
      'course_thumbnail': courseThumbnail,
      'status': status,
      'issued_at': issuedAt?.toIso8601String(),
      'expired_at': expiredAt?.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isGenerated => status == 'generated' || status == 'issued';
  bool get isExpired => expiredAt != null && DateTime.now().isAfter(expiredAt!);

  String get statusText {
    if (isExpired) return 'Kedaluwarsa';
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'generated':
      case 'issued':
        return 'Terbit';
      case 'revoked':
        return 'Dicabut';
      default:
        return status;
    }
  }

  // Getter alias for screen compatibility - use course thumbnail for display
  String? get imageUrl => courseThumbnail ?? certificateUrl;
}

class CertificateStatusModel {
  final bool hasCertificate;
  final CertificateModel? certificate;
  final String? message;
  final String? status; // Backend status: AVAILABLE, INCOMPLETE, WAITING, NOT_ENROLLED
  final String? certificateUrl; // Direct URL from backend

  CertificateStatusModel({
    required this.hasCertificate,
    this.certificate,
    this.message,
    this.status,
    this.certificateUrl,
  });

  factory CertificateStatusModel.fromJson(Map<String, dynamic> json) {
    // Handle backend response format:
    // {status: 'AVAILABLE', message: '...', certificate_url: '...'}
    // OR legacy format: {has_certificate: true, certificate: {...}}
    
    final backendStatus = json['status'] as String?;
    final certificateUrl = json['certificate_url'] ?? json['certificateUrl'];
    
    // If backend returns status='AVAILABLE', certificate exists
    bool hasCert = json['has_certificate'] ?? json['hasCertificate'] ?? false;
    if (backendStatus == 'AVAILABLE' && certificateUrl != null) {
      hasCert = true;
    }
    
    // Build certificate model from backend response if status is AVAILABLE
    CertificateModel? cert;
    if (json['certificate'] != null) {
      cert = CertificateModel.fromJson(json['certificate']);
    } else if (backendStatus == 'AVAILABLE' && certificateUrl != null) {
      // Create a minimal certificate model from the status response
      cert = CertificateModel(
        id: '',
        courseName: '',
        certificateNumber: '',
        certificateUrl: certificateUrl,
        createdAt: DateTime.now(),
      );
    }
    
    return CertificateStatusModel(
      hasCertificate: hasCert,
      certificate: cert,
      message: json['message'],
      status: backendStatus,
      certificateUrl: certificateUrl,
    );
  }
}

class CourseCompletionModel {
  final bool isCompleted;
  final bool isEligible;
  final int completionPercentage;
  final int? quizScore;
  final int? requiredScore;
  final String? message;

  CourseCompletionModel({
    required this.isCompleted,
    required this.isEligible,
    this.completionPercentage = 0,
    this.quizScore,
    this.requiredScore,
    this.message,
  });

  factory CourseCompletionModel.fromJson(Map<String, dynamic> json) {
    return CourseCompletionModel(
      isCompleted: json['is_completed'] ?? json['isCompleted'] ?? false,
      isEligible: json['is_eligible'] ?? json['isEligible'] ?? false,
      completionPercentage: json['completion_percentage'] ?? json['completionPercentage'] ?? 0,
      quizScore: json['quiz_score'] ?? json['quizScore'],
      requiredScore: json['required_score'] ?? json['requiredScore'],
      message: json['message'],
    );
  }
}

class CertificateTemplateModel {
  final String id;
  final String name;
  final String? description;
  final String? previewUrl;
  final bool isDefault;

  CertificateTemplateModel({
    required this.id,
    required this.name,
    this.description,
    this.previewUrl,
    this.isDefault = false,
  });

  factory CertificateTemplateModel.fromJson(Map<String, dynamic> json) {
    return CertificateTemplateModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['title'] ?? '',
      description: json['description'],
      previewUrl: json['preview_url'] ?? json['previewUrl'] ?? json['template_url'],
      isDefault: json['is_default'] ?? json['isDefault'] ?? false,
    );
  }
}

class CertificatePreviewModel {
  final String previewUrl;
  final String? recipientName;
  final String? courseName;
  final String? completionDate;

  CertificatePreviewModel({
    required this.previewUrl,
    this.recipientName,
    this.courseName,
    this.completionDate,
  });

  factory CertificatePreviewModel.fromJson(Map<String, dynamic> json) {
    return CertificatePreviewModel(
      previewUrl: json['preview_url'] ?? json['previewUrl'] ?? '',
      recipientName: json['recipient_name'] ?? json['recipientName'],
      courseName: json['course_name'] ?? json['courseName'],
      completionDate: json['completion_date'] ?? json['completionDate'],
    );
  }
}
