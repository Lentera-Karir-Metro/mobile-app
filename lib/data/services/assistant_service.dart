import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lentera_karir/data/api/endpoints.dart';

/// Service untuk berkomunikasi dengan AI Assistant API
/// Tidak menyimpan history chat - hanya mengirim pesan dan menerima response
class AssistantService {
  final String baseUrl = ApiEndpoints.baseUrl;
  
  // Timeout untuk request non-streaming
  static const Duration timeoutDuration = Duration(seconds: 60);

  /// Kirim pesan ke assistant dan terima response (non-streaming)
  /// 
  /// [message] - Pesan yang dikirim ke assistant
  /// [model] - Model AI yang digunakan (opsional)
  /// 
  /// Returns response text dari assistant
  Future<String> sendMessage(String message, {String? model}) async {
    try {
      final uri = Uri.parse('$baseUrl/assistant');
      
      debugPrint('🤖 [AssistantService] Sending POST to: $uri');
      
      final body = {
        'message': message,
        'stream': false,
        if (model != null) 'model': model,
      };
      
      debugPrint('🤖 [AssistantService] Request body: $body');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode(body),
      ).timeout(
        timeoutDuration,
        onTimeout: () {
          throw TimeoutException('Request timeout - Server tidak merespons');
        },
      );
      
      debugPrint('🤖 [AssistantService] Response status: ${response.statusCode}');
      debugPrint('🤖 [AssistantService] Response body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');

      if (response.statusCode == 200) {
        // Response adalah plain text
        return response.body;
      } else if (response.statusCode == 401) {
        debugPrint('🤖 [AssistantService] 401 Unauthorized - ngrok session may have expired');
        throw Exception('Sesi server berakhir. Silakan restart ngrok tunnel atau hubungi admin.');
      } else if (response.statusCode == 429) {
        throw Exception('Kuota API habis. Silakan coba lagi nanti.');
      } else if (response.statusCode == 500) {
        // Coba parse error message dari JSON
        try {
          final errorData = jsonDecode(response.body);
          final errorMsg = errorData['error'] ?? errorData['details'] ?? 'Server error';
          throw Exception('Server error: $errorMsg');
        } catch (_) {
          throw Exception('Terjadi kesalahan server: ${response.statusCode}');
        }
      } else {
        // Coba parse error message dari JSON
        try {
          final errorData = jsonDecode(response.body);
          throw Exception(errorData['error'] ?? 'Terjadi kesalahan pada server');
        } catch (_) {
          throw Exception('Terjadi kesalahan: ${response.statusCode}');
        }
      }
    } on TimeoutException {
      throw Exception('Koneksi timeout. Periksa jaringan Anda.');
    } catch (e) {
      debugPrint('🤖 [AssistantService] Error: $e');
      if (e is Exception) rethrow;
      throw Exception('Gagal menghubungi server: $e');
    }
  }

  /// Kirim pesan ke assistant dengan streaming response
  /// 
  /// [message] - Pesan yang dikirim ke assistant
  /// [model] - Model AI yang digunakan (opsional)
  /// 
  /// Returns Stream of response chunks
  Stream<String> sendMessageStream(String message, {String? model}) async* {
    final uri = Uri.parse('$baseUrl/assistant');
    
    final request = http.Request('POST', uri)
      ..headers['Content-Type'] = 'application/json'
      ..headers['ngrok-skip-browser-warning'] = 'true'
      ..body = jsonEncode({
        'message': message,
        'stream': true,
        if (model != null) 'model': model,
      });

    final client = http.Client();
    
    try {
      final streamedResponse = await client.send(request).timeout(
        const Duration(seconds: 120),
        onTimeout: () {
          throw TimeoutException('Streaming timeout');
        },
      );

      if (streamedResponse.statusCode != 200) {
        final errorBody = await streamedResponse.stream.bytesToString();
        client.close();
        
        if (streamedResponse.statusCode == 429) {
          throw Exception('Kuota API habis. Silakan coba lagi nanti.');
        }
        
        try {
          final errorData = jsonDecode(errorBody);
          throw Exception(errorData['error'] ?? 'Terjadi kesalahan pada server');
        } catch (_) {
          throw Exception('Terjadi kesalahan: ${streamedResponse.statusCode}');
        }
      }

      // Decode dan yield chunks
      await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
        if (chunk.isNotEmpty) {
          yield chunk;
        }
      }
    } finally {
      client.close();
    }
  }

  /// Cek status assistant API
  Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('$baseUrl/assistant');
      final response = await http.get(
        uri,
        headers: {'ngrok-skip-browser-warning': 'true'},
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
