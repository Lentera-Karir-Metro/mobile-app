import 'package:flutter/material.dart';
import 'package:lentera_karir/data/services/assistant_service.dart';

/// Model untuk pesan chat
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  bool isLoading;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.isLoading = false,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create loading message untuk assistant
  factory ChatMessage.loading() {
    return ChatMessage(
      text: '',
      isUser: false,
      isLoading: true,
    );
  }
}

/// Provider untuk mengelola state Assistant Chat
/// Tidak menyimpan history ke storage - hanya in-memory
class AssistantProvider extends ChangeNotifier {
  final AssistantService _service;
  
  /// List pesan chat (in-memory only, tidak disimpan)
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  
  /// Status loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  /// Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Quick suggestions untuk user
  final List<String> quickSuggestions = [
    'Apa itu Lentera Karir?',
    'Rekomendasi learning path',
    'Cara mendaftar course',
    'Tips membangun karir',
    'Bagaimana cara menyelesaikan course?',
  ];

  AssistantProvider(this._service);

  /// Kirim pesan ke assistant
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    
    // Reset error
    _errorMessage = null;
    
    // Add user message
    _messages.add(ChatMessage(
      text: message.trim(),
      isUser: true,
    ));
    notifyListeners();
    
    // Add loading indicator untuk assistant
    _messages.add(ChatMessage.loading());
    _isLoading = true;
    notifyListeners();
    
    try {
      // Kirim ke API (non-streaming untuk kesederhanaan)
      final response = await _service.sendMessage(message.trim());
      
      // Replace loading message dengan response
      if (_messages.isNotEmpty && _messages.last.isLoading) {
        _messages.removeLast();
      }
      
      _messages.add(ChatMessage(
        text: response,
        isUser: false,
      ));
      
    } catch (e) {
      // Remove loading message
      if (_messages.isNotEmpty && _messages.last.isLoading) {
        _messages.removeLast();
      }
      
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      
      // Add error message sebagai assistant response
      _messages.add(ChatMessage(
        text: 'Maaf, terjadi kesalahan: $_errorMessage',
        isUser: false,
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Kirim pesan dengan streaming response
  Future<void> sendMessageWithStream(String message) async {
    if (message.trim().isEmpty) return;
    
    _errorMessage = null;
    
    // Add user message
    _messages.add(ChatMessage(
      text: message.trim(),
      isUser: true,
    ));
    notifyListeners();
    
    // Add empty assistant message untuk streaming
    final assistantMessage = ChatMessage(
      text: '',
      isUser: false,
      isLoading: true,
    );
    _messages.add(assistantMessage);
    _isLoading = true;
    notifyListeners();
    
    try {
      final stream = _service.sendMessageStream(message.trim());
      
      await for (final chunk in stream) {
        // Update assistant message dengan chunk baru
        final lastIndex = _messages.length - 1;
        if (lastIndex >= 0 && !_messages[lastIndex].isUser) {
          _messages[lastIndex] = ChatMessage(
            text: _messages[lastIndex].text + chunk,
            isUser: false,
            isLoading: true,
            timestamp: _messages[lastIndex].timestamp,
          );
          notifyListeners();
        }
      }
      
      // Mark as not loading
      final lastIndex = _messages.length - 1;
      if (lastIndex >= 0 && !_messages[lastIndex].isUser) {
        _messages[lastIndex].isLoading = false;
        notifyListeners();
      }
      
    } catch (e) {
      // Update loading message with error
      final lastIndex = _messages.length - 1;
      if (lastIndex >= 0 && !_messages[lastIndex].isUser) {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _messages[lastIndex] = ChatMessage(
          text: 'Maaf, terjadi kesalahan: $_errorMessage',
          isUser: false,
          timestamp: _messages[lastIndex].timestamp,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear semua pesan (reset chat)
  void clearMessages() {
    _messages.clear();
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
