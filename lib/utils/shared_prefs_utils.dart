import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPrefsUtils {
  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _userDataKey = "user_data";
  static const String _isLoggedInKey = "is_logged_in";
  static const String _deviceIdKey = "device_id";
  static const String _onboardingKey = "onboarding_complete";

  // Access Token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  static Future<bool> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_accessTokenKey, token);
  }

  // Refresh Token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  static Future<bool> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_refreshTokenKey, token);
  }

  // Save both tokens
  static Future<bool> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final accessResult = await saveAccessToken(accessToken);
    final refreshResult = await saveRefreshToken(refreshToken);
    return accessResult && refreshResult;
  }

  // User Data
  static Future<bool> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userDataKey, jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userDataKey);
    if (jsonString == null) return null;
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Login Status
  static Future<bool> setLoggedIn(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isLoggedInKey, status);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Device ID
  static Future<String?> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceIdKey);
  }

  static Future<bool> saveDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_deviceIdKey, deviceId);
  }

  // Onboarding
  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<bool> setOnboardingComplete(bool complete) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_onboardingKey, complete);
  }

  // Clear all data (for logout)
  static Future<bool> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString(_deviceIdKey);
    final onboarding = prefs.getBool(_onboardingKey) ?? false;

    await prefs.clear();

    // Restore device ID and onboarding
    if (deviceId != null) await prefs.setString(_deviceIdKey, deviceId);
    await prefs.setBool(_onboardingKey, onboarding);

    return true;
  }
}
