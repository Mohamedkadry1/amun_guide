class CommentModel {
  final int id;
  final String content;
  final String? userName;
  final String? userImage;
  final String? createdAt;

  CommentModel({
    required this.id,
    required this.content,
    this.userName,
    this.userImage,
    this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      userName: json['user']?['name'],
      userImage: json['user']?['profile_image'],
      createdAt: json['created_at'],
    );
  }
}
