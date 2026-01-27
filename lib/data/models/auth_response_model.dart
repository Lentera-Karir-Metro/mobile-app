import 'package:lentera_karir/data/models/user_model.dart';

class AuthResponseModel {
  final bool success;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;
  final bool isNetworkError;

  AuthResponseModel({
    required this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.isNetworkError = false,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Backend login returns: { message, token, refreshToken, user }
    // NOT wrapped in 'data' object
    final data = json['data'] ?? json;

    return AuthResponseModel(
      success: json['success'] ?? (json['token'] != null),
      message: json['message'] ?? data['message'],
      // Backend returns 'token' not 'access_token'
      accessToken: data['token'] ?? data['access_token'] ?? data['accessToken'],
      refreshToken: data['refreshToken'] ?? data['refresh_token'],
      user: data['user'] != null ? UserModel.fromJson(data['user']) : null,
      isNetworkError: json['isNetworkError'] ?? false,
    );
  }

  factory AuthResponseModel.error(
    String message, {
    bool isNetworkError = false,
  }) {
    return AuthResponseModel(
      success: false,
      message: message,
      isNetworkError: isNetworkError,
    );
  }
}

class RegisterResponseModel {
  final bool success;
  final String? message;
  final String? userId;
  final String? email;
  final String? username;
  final bool isNetworkError;

  RegisterResponseModel({
    required this.success,
    this.message,
    this.userId,
    this.email,
    this.username,
    this.isNetworkError = false,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    // Backend register returns: { message, user: { id, username, email } }
    final user = json['user'] ?? json['data']?['user'];

    return RegisterResponseModel(
      success: json['success'] ?? (json['user'] != null),
      message: json['message'],
      userId: user?['id']?.toString(),
      email: user?['email'],
      username: user?['username'],
      isNetworkError: json['isNetworkError'] ?? false,
    );
  }
}

class VerifyEmailResponseModel {
  final bool success;
  final String? message;
  final String? email;
  final bool isNetworkError;

  VerifyEmailResponseModel({
    required this.success,
    this.message,
    this.email,
    this.isNetworkError = false,
  });

  factory VerifyEmailResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailResponseModel(
      success: json['success'] ?? (json['email'] != null),
      message: json['message'],
      email: json['email'],
      isNetworkError: json['isNetworkError'] ?? false,
    );
  }
}

class ForgotPasswordResponseModel {
  final bool success;
  final String? message;
  final bool isNetworkError;

  ForgotPasswordResponseModel({
    required this.success,
    this.message,
    this.isNetworkError = false,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      success:
          json['success'] ?? true, // Backend always returns 200 for security
      message: json['message'],
      isNetworkError: json['isNetworkError'] ?? false,
    );
  }
}

class CheckStatusResponseModel {
  final bool success;
  final String? status;
  final bool isNetworkError;

  CheckStatusResponseModel({
    required this.success,
    this.status,
    this.isNetworkError = false,
  });

  factory CheckStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckStatusResponseModel(
      success: json['success'] ?? false,
      status: json['data']?['status'],
      isNetworkError: json['isNetworkError'] ?? false,
    );
  }
}
