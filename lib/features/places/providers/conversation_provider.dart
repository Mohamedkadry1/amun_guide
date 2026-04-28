import 'package:flutter/material.dart';
import '../models/conversation_models.dart';
import '../repositories/conversation_repository.dart';

class ConversationProvider extends ChangeNotifier {
  final ConversationRepository _repository;

  ConversationProvider(this._repository);

  // State
  List<Conversation> _conversations = [];
  Conversation? _currentConversation;
  List<Message> _messages = [];
  List<GeneratedImage> _generatedImages = [];
  bool _isLoading = false;
  bool _isSendingMessage = false;
  String? _errorMessage;
  ConversationStats? _stats;

  // Getters
  List<Conversation> get conversations => _conversations;
  Conversation? get currentConversation => _currentConversation;
  List<Message> get messages => _messages;
  List<GeneratedImage> get generatedImages => _generatedImages;
  bool get isLoading => _isLoading;
  bool get isSendingMessage => _isSendingMessage;
  String? get errorMessage => _errorMessage;
  ConversationStats? get stats => _stats;

  /// Create a new conversation
  Future<Conversation> createConversation({required String context}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final conversation = await _repository.createConversation(context: context);
      _currentConversation = conversation;
      _messages = conversation.messages;
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();

      return conversation;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Load all conversations
  Future<void> loadConversations({
    String? context,
    bool? withImages,
    int page = 1,
  }) async {
    if (page == 1) {
      _conversations = [];
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getConversations(
        context: context,
        withImages: withImages,
        page: page,
      );

      _conversations.addAll(response.conversations);
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _conversations = [];
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Load specific conversation
  Future<void> loadConversation(int conversationId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentConversation = await _repository.getConversation(conversationId);
      _messages = _currentConversation?.messages ?? [];
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _currentConversation = null;
      _messages = [];
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Send a message in current conversation
  Future<void> sendMessage({
    required String message,
    String? imageUrl,
    int? placeId,
  }) async {
    if (_currentConversation == null) {
      _errorMessage = 'No conversation selected';
      notifyListeners();
      return;
    }

    try {
      _isSendingMessage = true;
      _errorMessage = null;
      notifyListeners();

      // First, send user message
      final userMessage = await _repository.sendMessage(
        conversationId: _currentConversation!.id,
        sender: 'user',
        message: message,
        imageUrl: imageUrl,
        placeId: placeId,
      );

      _messages.add(userMessage);
      _errorMessage = null;
      notifyListeners();

      // Then get bot response (API will generate it)
      final response = await _repository.sendMessage(
        conversationId: _currentConversation!.id,
        sender: 'bot',
        message: message, // API uses this as context to generate response
      );

      _messages.add(response);
      _errorMessage = null;

      _isSendingMessage = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isSendingMessage = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Load messages for current conversation
  Future<void> loadMessages({int page = 1}) async {
    if (_currentConversation == null) {
      return;
    }

    if (page == 1) {
      _messages = [];
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final messagesList = await _repository.getMessages(
        conversationId: _currentConversation!.id,
        page: page,
      );

      _messages.addAll(messagesList);
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load generated images from current conversation
  Future<void> loadGeneratedImages({int page = 1}) async {
    if (_currentConversation == null) {
      return;
    }

    if (page == 1) {
      _generatedImages = [];
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final imagesList = await _repository.getConversationImages(
        conversationId: _currentConversation!.id,
        page: page,
      );

      _generatedImages.addAll(imagesList);
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load conversation statistics
  Future<void> loadStatistics() async {
    try {
      _stats = await _repository.getStatistics();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Delete conversation
  Future<void> deleteConversation(int conversationId) async {
    try {
      await _repository.deleteConversation(conversationId);

      // Remove from list
      _conversations.removeWhere((c) => c.id == conversationId);

      // Clear current if it was deleted
      if (_currentConversation?.id == conversationId) {
        _currentConversation = null;
        _messages = [];
      }

      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Reset state
  void resetConversation() {
    _currentConversation = null;
    _messages = [];
    _generatedImages = [];
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all conversations
  void clearConversations() {
    _conversations = [];
    _currentConversation = null;
    _messages = [];
    _generatedImages = [];
    _errorMessage = null;
    notifyListeners();
  }
}
