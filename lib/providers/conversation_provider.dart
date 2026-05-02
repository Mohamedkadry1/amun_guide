import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/conversation_model.dart';
import '../data/services/conversation_service.dart';
import '../data/services/api_client.dart';

class ConversationProvider extends ChangeNotifier {
  final _service = ConversationService();

  List<ConversationModel> _conversations = [];
  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ConversationModel> get conversations => _conversations;
  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadConversations() async {
    _setLoading(true);
    _error = null;
    try {
      _conversations = await _service.getConversations();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMessages(int conversationId) async {
    _setLoading(true);
    _error = null;
    try {
      _messages = await _service.getMessages(conversationId);
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendMessage(int conversationId, String text) async {
    _error = null;
    try {
      final msg = await _service.sendMessage(conversationId, text);
      _messages.add(msg);
      notifyListeners();
      
      // AI normally replies automatically on backend, so we might need to reload messages
      // or the backend might return the AI reply in the same response or we poll.
      // Assuming for now we reload or the backend handles it.
      await loadMessages(conversationId); 
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
      notifyListeners();
    }
  }

  Future<ConversationModel?> startNewConversation() async {
    _setLoading(true);
    _error = null;
    try {
      final conv = await _service.createConversation();
      await loadConversations();
      return conv;
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
      return null;
    } finally {
      _setLoading(false);
    }
  }
}
