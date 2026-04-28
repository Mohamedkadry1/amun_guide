import '../models/conversation_models.dart';
import '../../../core/services/api_service.dart';

class ConversationRepository {
  final ApiService _apiService;

  ConversationRepository(this._apiService);

  /// Create a new conversation
  Future<Conversation> createConversation({
    required String context, // 'image_generation', 'travel_plan', 'info_request', 'general', 'place_inquiry', 'tour_inquiry'
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/conversations',
        data: {'context': context},
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to create conversation');
      }

      final conversationData = response.data?['data'] ?? response.data;
      return Conversation.fromJson(conversationData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error creating conversation: $e');
    }
  }

  /// Get all conversations for current user
  Future<ConversationsResponse> getConversations({
    String? context,
    bool? withImages,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      String query = '?page=$page&per_page=$perPage';
      if (context != null) {
        query += '&context=$context';
      }
      if (withImages != null) {
        query += '&with_images=${withImages ? 1 : 0}';
      }

      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/conversations$query',
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to fetch conversations');
      }

      return ConversationsResponse.fromJson(response.data ?? {});
    } catch (e) {
      throw Exception('Error fetching conversations: $e');
    }
  }

  /// Get single conversation with messages
  Future<Conversation> getConversation(int conversationId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/conversations/$conversationId',
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to fetch conversation');
      }

      final conversationData = response.data?['data'] ?? response.data;
      return Conversation.fromJson(conversationData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error fetching conversation: $e');
    }
  }

  /// Send message in conversation
  Future<Message> sendMessage({
    required int conversationId,
    required String sender, // 'user' or 'bot'
    required String message,
    String? imageUrl,
    int? placeId,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/conversations/$conversationId/messages',
        data: {
          'sender': sender,
          'message': message,
          if (imageUrl != null) 'image_url': imageUrl,
          if (placeId != null) 'place_id': placeId,
        },
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to send message');
      }

      final messageData = response.data?['data'] ?? response.data;
      return Message.fromJson(messageData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  /// Get conversation messages
  Future<List<Message>> getMessages({
    required int conversationId,
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      final query = '?page=$page&per_page=$perPage';
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/conversations/$conversationId/messages$query',
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to fetch messages');
      }

      final data = response.data ?? {};
      final messagesList = (data['data'] as List?)
          ?.map((m) => Message.fromJson(m as Map<String, dynamic>))
          .toList() ??
          [];
      return messagesList;
    } catch (e) {
      throw Exception('Error fetching messages: $e');
    }
  }

  /// Get generated images in conversation
  Future<List<GeneratedImage>> getConversationImages({
    required int conversationId,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final query = '?page=$page&per_page=$perPage';
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/conversations/$conversationId/images$query',
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to fetch images');
      }

      final data = response.data ?? {};
      final imagesList = (data['data'] as List?)
          ?.map((i) => GeneratedImage.fromJson(i as Map<String, dynamic>))
          .toList() ??
          [];
      return imagesList;
    } catch (e) {
      throw Exception('Error fetching images: $e');
    }
  }

  /// Get conversation statistics
  Future<ConversationStats> getStatistics() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/conversations/statistics',
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to fetch statistics');
      }

      final statsData = response.data ?? {};
      return ConversationStats.fromJson(statsData);
    } catch (e) {
      throw Exception('Error fetching statistics: $e');
    }
  }

  /// Delete conversation
  Future<void> deleteConversation(int conversationId) async {
    try {
      final response = await _apiService.delete<Map<String, dynamic>>(
        endpoint: '/conversations/$conversationId',
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to delete conversation');
      }
    } catch (e) {
      throw Exception('Error deleting conversation: $e');
    }
  }
}
