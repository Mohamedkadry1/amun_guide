class ConversationModel {
  final int id;
  final String? title;
  final String? lastMessage;
  final String? createdAt;

  ConversationModel({
    required this.id,
    this.title,
    this.lastMessage,
    this.createdAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? 0,
      title: json['title'],
      lastMessage: json['last_message'],
      createdAt: json['created_at'],
    );
  }
}

class MessageModel {
  final int id;
  final String sender; // 'user' or 'ai'
  final String message;
  final String? createdAt;

  MessageModel({
    required this.id,
    required this.sender,
    required this.message,
    this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      sender: json['sender'] ?? 'user',
      message: json['message'] ?? '',
      createdAt: json['created_at'],
    );
  }
}
