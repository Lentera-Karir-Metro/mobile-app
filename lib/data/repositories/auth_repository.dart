import 'package:lentera_karir/data/models/auth_response_model.dart';
import 'package:lentera_karir/data/models/user_model.dart';
import 'package:lentera_karir/data/services/auth_service.dart';
import 'package:lentera_karir/utils/shared_prefs_utils.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> login(String email, String password);
  Future<RegisterResponseModel> register(
    String name,
    String email,
    String password, {
    String? phone,
  });
  Future<VerifyEmailResponseModel> verifyEmail(String token);
  Future<ForgotPasswordResponseModel> forgotPassword(String email);
  Future<bool> resetPassword(String token, String password);
  Future<bool> refreshToken();
  Future<UserModel?> getCurrentUser();
  Future<CheckStatusResponseModel> checkStatus();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final response = await _authService.login(email: email, password: password);

    if (response['success'] == true) {
      final authResponse = AuthResponseModel.fromJson(response);

      // Save tokens
      if (authResponse.accessToken != null &&
          authResponse.refreshToken != null) {
        await SharedPrefsUtils.saveTokens(
          accessToken: authResponse.accessToken!,
          refreshToken: authResponse.refreshToken!,
        );
      }

      // Save user data
      if (authResponse.user != null) {
        await SharedPrefsUtils.saveUserData(authResponse.user!.toJson());
      }

      await SharedPrefsUtils.setLoggedIn(true);
      return authResponse;
    }

    return AuthResponseModel.error(response['message'] ?? 'Login gagal');
  }

  @override
  Future<RegisterResponseModel> register(
    String name,
    String email,
    String password, {
    String? phone,
  }) async {
    final response = await _authService.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );

    return RegisterResponseModel.fromJson(response);
  }

  @override
  Future<VerifyEmailResponseModel> verifyEmail(String token) async {
    final response = await _authService.verifyEmail(token: token);
    return VerifyEmailResponseModel.fromJson(response);
  }

  @override
  Future<ForgotPasswordResponseModel> forgotPassword(String email) async {
    final response = await _authService.forgotPassword(email: email);
    return ForgotPasswordResponseModel.fromJson(response);
  }

  @override
  Future<bool> resetPassword(String token, String password) async {
    final response = await _authService.resetPassword(
      token: token,
      password: password,
    );
    return response['success'] == true;
  }

  @override
  Future<bool> refreshToken() async {
    final currentRefreshToken = await SharedPrefsUtils.getRefreshToken();
    if (currentRefreshToken == null) return false;

    final response = await _authService.refreshToken(
      refreshToken: currentRefreshToken,
    );

    if (response['success'] == true) {
      final data = response['data'];
      // Backend returns 'token' for new access token
      await SharedPrefsUtils.saveTokens(
        accessToken: data['token'] ?? data['access_token'] ?? data['accessToken'],
        refreshToken: currentRefreshToken, // Keep existing refresh token
      );
      return true;
    }

    return false;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final response = await _authService.getCurrentUser();

    if (response['success'] == true && response['data'] != null) {
      final user = UserModel.fromJson(response['data']);
      await SharedPrefsUtils.saveUserData(user.toJson());
      return user;
    }

    return null;
  }

  @override
  Future<CheckStatusResponseModel> checkStatus() async {
    final response = await _authService.checkStatus();
    return CheckStatusResponseModel.fromJson(response);
  }

  @override
  Future<void> logout() async {
    await SharedPrefsUtils.clearAllData();
  }
}
