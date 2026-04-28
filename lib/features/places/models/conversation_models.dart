/// Message in a conversation
class Message {
  final int id;
  final int conversationId;
  final String sender; // 'user' or 'bot'
  final String message;
  final String? imageUrl;
  final int? placeId;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.message,
    this.imageUrl,
    this.placeId,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      conversationId: json['conversation_id'] as int,
      sender: json['sender'] as String,
      message: json['message'] as String,
      imageUrl: json['image_url'] as String?,
      placeId: json['place_id'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversation_id': conversationId,
    'sender': sender,
    'message': message,
    'image_url': imageUrl,
    'place_id': placeId,
    'created_at': createdAt.toIso8601String(),
  };

  bool get isUserMessage => sender == 'user';
  bool get isBotMessage => sender == 'bot';
}

/// Conversation with AI
class Conversation {
  final int id;
  final int userId;
  final String context; // 'image_generation', 'travel_plan', 'info_request', 'general', 'place_inquiry', 'tour_inquiry'
  final List<Message> messages;
  final int imagesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.userId,
    required this.context,
    required this.messages,
    required this.imagesCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      context: json['context'] as String,
      messages: (json['messages'] as List?)
          ?.map((m) => Message.fromJson(m as Map<String, dynamic>))
          .toList() ??
          [],
      imagesCount: json['images_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'context': context,
    'messages': messages.map((m) => m.toJson()).toList(),
    'images_count': imagesCount,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}

/// Response with generated image
class GeneratedImage {
  final int id;
  final int conversationId;
  final int messageId;
  final String imageUrl;
  final String prompt;
  final DateTime createdAt;

  GeneratedImage({
    required this.id,
    required this.conversationId,
    required this.messageId,
    required this.imageUrl,
    required this.prompt,
    required this.createdAt,
  });

  factory GeneratedImage.fromJson(Map<String, dynamic> json) {
    return GeneratedImage(
      id: json['id'] as int,
      conversationId: json['conversation_id'] as int,
      messageId: json['message_id'] as int,
      imageUrl: json['image_url'] as String,
      prompt: json['prompt'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversation_id': conversationId,
    'message_id': messageId,
    'image_url': imageUrl,
    'prompt': prompt,
    'created_at': createdAt.toIso8601String(),
  };
}

/// Response wrapper for conversations list
class ConversationsResponse {
  final List<Conversation> conversations;
  final int total;
  final int page;
  final int perPage;

  ConversationsResponse({
    required this.conversations,
    required this.total,
    required this.page,
    required this.perPage,
  });

  factory ConversationsResponse.fromJson(Map<String, dynamic> json) {
    return ConversationsResponse(
      conversations: (json['data'] as List?)
          ?.map((c) => Conversation.fromJson(c as Map<String, dynamic>))
          .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['current_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
    );
  }
}

/// Conversation statistics
class ConversationStats {
  final int totalConversations;
  final Map<String, int> byContext; // e.g., {'image_generation': 5, 'travel_plan': 3}

  ConversationStats({
    required this.totalConversations,
    required this.byContext,
  });

  factory ConversationStats.fromJson(Map<String, dynamic> json) {
    return ConversationStats(
      totalConversations: json['total'] as int? ?? 0,
      byContext: Map<String, int>.from(
        (json['by_context'] as Map?)?.cast<String, int>() ?? {},
      ),
    );
  }
}
