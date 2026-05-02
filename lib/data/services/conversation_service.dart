import '../models/conversation_model.dart';
import 'api_client.dart';

class ConversationService {
  final _dio = ApiClient().dio;

  Future<List<ConversationModel>> getConversations() async {
    final res = await _dio.get('/api/v1/conversations');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => ConversationModel.fromJson(e)).toList();
  }

  Future<ConversationModel> createConversation({String context = 'travel'}) async {
    final res = await _dio.post('/api/v1/conversations', data: {'context': context});
    final data = res.data['data'] ?? res.data;
    return ConversationModel.fromJson(data);
  }

  Future<List<MessageModel>> getMessages(int conversationId) async {
    final res = await _dio.get('/api/v1/conversations/$conversationId/messages');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => MessageModel.fromJson(e)).toList();
  }

  Future<MessageModel> sendMessage(int conversationId, String message) async {
    final res = await _dio.post('/api/v1/conversations/$conversationId/messages', data: {
      'sender': 'user',
      'message': message,
    });
    final data = res.data['data'] ?? res.data;
    return MessageModel.fromJson(data);
  }
}
