import 'package:lentera_karir/data/api/api_service.dart';
import 'package:lentera_karir/data/api/endpoints.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  // Register - backend expects 'username' or 'name', email, password
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    return await _apiService.post(
      ApiEndpoints.register,
      body: {
        'username': name, // Backend accepts 'username' or 'name'
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      },
      requiresAuth: false,
    );
  }

  // Verify Email - backend uses GET with query param ?token=
  Future<Map<String, dynamic>> verifyEmail({required String token}) async {
    return await _apiService.get(
      '${ApiEndpoints.verifyEmail}?token=$token',
      requiresAuth: false,
    );
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _apiService.post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
      requiresAuth: false,
    );
  }

  // Forgot Password
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    return await _apiService.post(
      ApiEndpoints.forgotPassword,
      body: {'email': email},
      requiresAuth: false,
    );
  }

  // Reset Password - backend expects 'token', 'newPassword' or 'password'
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String password,
  }) async {
    return await _apiService.post(
      ApiEndpoints.resetPassword,
      body: {
        'token': token,
        'newPassword': password,
        'password': password,
      },
      requiresAuth: false,
    );
  }

  // Refresh Token - backend expects 'refreshToken'
  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    return await _apiService.post(
      ApiEndpoints.refreshToken,
      body: {'refreshToken': refreshToken},
      requiresAuth: false,
    );
  }

  // Get current user (me)
  Future<Map<String, dynamic>> getCurrentUser() async {
    return await _apiService.get(ApiEndpoints.me);
  }

  // Check auth status
  Future<Map<String, dynamic>> checkStatus() async {
    return await _apiService.get(ApiEndpoints.checkStatus);
  }
}
