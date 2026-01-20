class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final bool emailVerified;
  final String? role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.emailVerified = false,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse id safely - backend might send String or int
    int parsedId = 0;
    if (json['id'] != null) {
      if (json['id'] is int) {
        parsedId = json['id'];
      } else if (json['id'] is String) {
        parsedId = int.tryParse(json['id']) ?? 0;
      }
    }
    
    return UserModel(
      id: parsedId,
      name: json['name'] ?? json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      emailVerified: json['email_verified'] ?? json['emailVerified'] ?? json['is_verified'] ?? false,
      role: json['role'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'email_verified': emailVerified,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Getter alias for screen compatibility
  String? get profilePicture => avatar;

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    bool? emailVerified,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      emailVerified: emailVerified ?? this.emailVerified,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
