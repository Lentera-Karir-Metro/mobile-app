import 'package:flutter/material.dart';
import 'package:lentera_karir/data/models/auth_response_model.dart';
import 'package:lentera_karir/data/models/user_model.dart';
import 'package:lentera_karir/data/repositories/auth_repository.dart';
import 'package:lentera_karir/utils/shared_prefs_utils.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  networkError,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;
  bool _isNetworkError = false;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isNetworkError => _isNetworkError;

  // Initialize - check if user is logged in
  Future<void> initialize() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final isLoggedIn = await SharedPrefsUtils.isLoggedIn();

    if (isLoggedIn) {
      final userData = await SharedPrefsUtils.getUserData();
      if (userData != null) {
        _user = UserModel.fromJson(userData);
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    _isNetworkError = false;
    notifyListeners();

    final response = await _authRepository.login(email, password);

    if (response.success && response.user != null) {
      _user = response.user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    }

    // Check if it's a network error
    _isNetworkError = response.isNetworkError;
    _errorMessage = response.message ?? 'Login gagal';
    _status = _isNetworkError ? AuthStatus.networkError : AuthStatus.error;
    notifyListeners();
    return false;
  }

  // Register
  Future<RegisterResponseModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    _isNetworkError = false;
    notifyListeners();

    final response = await _authRepository.register(
      name,
      email,
      password,
      phone: phone,
    );

    if (!response.success) {
      _isNetworkError = response.isNetworkError;
      _errorMessage = response.message;
      _status = _isNetworkError ? AuthStatus.networkError : AuthStatus.error;
    } else {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
    return response;
  }

  // Verify Email
  Future<VerifyEmailResponseModel> verifyEmail(String token) async {
    return await _authRepository.verifyEmail(token);
  }

  // Forgot Password
  Future<ForgotPasswordResponseModel> forgotPassword(String email) async {
    _status = AuthStatus.loading;
    _isNetworkError = false;
    notifyListeners();

    final response = await _authRepository.forgotPassword(email);

    _isNetworkError = response.isNetworkError;
    _status = _isNetworkError
        ? AuthStatus.networkError
        : AuthStatus.unauthenticated;
    notifyListeners();

    return response;
  }

  // Reset Password
  Future<bool> resetPassword(String token, String password) async {
    _status = AuthStatus.loading;
    _isNetworkError = false;
    notifyListeners();

    final success = await _authRepository.resetPassword(token, password);

    _status = AuthStatus.unauthenticated;
    notifyListeners();

    return success;
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();

    await _authRepository.logout();

    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    _isNetworkError = false;
    if (_status == AuthStatus.error || _status == AuthStatus.networkError) {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}
