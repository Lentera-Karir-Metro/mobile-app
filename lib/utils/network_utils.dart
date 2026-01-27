import 'dart:io';

/// Utility class for checking network connectivity
class NetworkUtils {
  /// Check if device has internet connectivity
  /// Returns true if connected, false otherwise
  static Future<bool> hasInternetConnection() async {
    try {
      // Try to lookup google.com DNS
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on Exception catch (_) {
      return false;
    }
  }

  /// Parse network error message to determine if it's a connectivity issue
  static bool isNetworkError(String? errorMessage) {
    if (errorMessage == null) return false;

    final networkErrorPatterns = [
      'SocketException',
      'Network is unreachable',
      'Connection refused',
      'Connection reset',
      'Failed host lookup',
      'No address associated',
      'Network error',
      'timeout',
      'Timeout',
      'Connection timed out',
      'Unable to resolve host',
    ];

    for (final pattern in networkErrorPatterns) {
      if (errorMessage.contains(pattern)) {
        return true;
      }
    }
    return false;
  }
}
