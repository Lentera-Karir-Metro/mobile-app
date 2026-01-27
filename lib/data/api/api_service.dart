import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:lentera_karir/data/api/endpoints.dart';
import 'package:lentera_karir/utils/shared_prefs_utils.dart';

class ApiService {
  final String baseUrl = ApiEndpoints.baseUrl;
  final Logger logger = Logger();

  // Timeout configuration
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Get headers with auth token
  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "ngrok-skip-browser-warning": "true",
    };

    if (requiresAuth) {
      final token = await SharedPrefsUtils.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return headers;
  }

  /// Check if error is a network connectivity issue
  bool _isNetworkError(dynamic error) {
    if (error == null) return false;

    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('socketexception') ||
        errorStr.contains('network is unreachable') ||
        errorStr.contains('connection refused') ||
        errorStr.contains('failed host lookup') ||
        errorStr.contains('no address associated') ||
        errorStr.contains('connection reset') ||
        errorStr.contains('connection timed out') ||
        errorStr.contains('unable to resolve host') ||
        errorStr.contains('timeout');
  }

  // GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requiresAuth = true,
    Map<String, String>? queryParams,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      var uri = Uri.parse('$baseUrl$endpoint');

      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      logger.d("GET Request: $uri");
      final response = await http
          .get(uri, headers: headers)
          .timeout(
            timeoutDuration,
            onTimeout: () {
              throw const SocketException(
                'Request timeout - Server tidak merespons',
              );
            },
          );
      logger.d("Response Status: ${response.statusCode}");

      return _handleResponse(response);
    } catch (e) {
      logger.e("GET Error: $e");
      return _handleError(e);
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final url = Uri.parse('$baseUrl$endpoint');

      logger.d("POST Request: $url");
      logger.d("POST Body: $body");

      final response = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(
            timeoutDuration,
            onTimeout: () {
              throw const SocketException(
                'Request timeout - Server tidak merespons',
              );
            },
          );

      logger.d("Response Status: ${response.statusCode}");
      // Log response body to help debugging server-side 500 errors
      try {
        logger.d("Response Body: ${response.body}");
      } catch (_) {}
      return _handleResponse(response);
    } catch (e) {
      logger.e("POST Error: $e");
      return _handleError(e);
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final url = Uri.parse('$baseUrl$endpoint');

      logger.d("PUT Request: $url");
      final response = await http
          .put(url, headers: headers, body: jsonEncode(body))
          .timeout(
            timeoutDuration,
            onTimeout: () {
              throw const SocketException(
                'Request timeout - Server tidak merespons',
              );
            },
          );

      return _handleResponse(response);
    } catch (e) {
      logger.e("PUT Error: $e");
      return _handleError(e);
    }
  }

  // PATCH request
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final url = Uri.parse('$baseUrl$endpoint');

      logger.d("PATCH Request: $url");
      final response = await http
          .patch(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(
            timeoutDuration,
            onTimeout: () {
              throw const SocketException(
                'Request timeout - Server tidak merespons',
              );
            },
          );

      return _handleResponse(response);
    } catch (e) {
      logger.e("PATCH Error: $e");
      return _handleError(e);
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final url = Uri.parse('$baseUrl$endpoint');

      logger.d("DELETE Request: $url");
      final response = await http
          .delete(url, headers: headers)
          .timeout(
            timeoutDuration,
            onTimeout: () {
              throw const SocketException(
                'Request timeout - Server tidak merespons',
              );
            },
          );

      return _handleResponse(response);
    } catch (e) {
      logger.e("DELETE Error: $e");
      return _handleError(e);
    }
  }

  /// Handle error and return appropriate response
  Map<String, dynamic> _handleError(dynamic error) {
    final isNetwork = _isNetworkError(error);
    return {
      "success": false,
      "isNetworkError": isNetwork,
      "message": isNetwork
          ? "Koneksi jaringan Anda bermasalah. Silakan periksa koneksi internet Anda."
          : "Terjadi kesalahan: $error",
    };
  }

  // Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // If backend already returns { success: true, data: ... }, pass it through
        if (data is Map<String, dynamic> && data.containsKey('success')) {
          return data;
        }
        // Otherwise wrap it
        return {"success": true, "data": data};
      } else {
        String errorMessage =
            data["message"] ?? data["error"] ?? "Unknown error";
        return {
          "success": false,
          "isNetworkError": false,
          "message": errorMessage,
          "statusCode": response.statusCode,
        };
      }
    } catch (e) {
      logger.e("Response parsing error: $e");
      return {
        "success": false,
        "isNetworkError": false,
        "message": "Failed to parse response",
        "statusCode": response.statusCode,
      };
    }
  }

  // Download file (for certificates, ebooks)
  Future<List<int>?> downloadFile(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      headers.remove("Content-Type");

      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(url, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      logger.e("Download Error: $e");
      return null;
    }
  }
}
