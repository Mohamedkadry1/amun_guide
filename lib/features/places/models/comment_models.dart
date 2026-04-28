/// Comment Model for Places, Tours, and Plans
class Comment {
  final int id;
  final int userId;
  final String userName;
  final String? userImage;
  final String content;
  final String commentableType; // 'places', 'tours', 'plans'
  final int commentableId;
  final int likesCount;
  final int repliesCount;
  final bool isLikedByMe;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.content,
    required this.commentableType,
    required this.commentableId,
    required this.likesCount,
    required this.repliesCount,
    required this.isLikedByMe,
    required this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      userName: json['user_name'] as String? ?? 'Anonymous',
      userImage: json['user_image'] as String?,
      content: json['content'] as String,
      commentableType: json['commentable_type'] as String,
      commentableId: json['commentable_id'] as int,
      likesCount: json['likes_count'] as int? ?? 0,
      repliesCount: json['replies_count'] as int? ?? 0,
      isLikedByMe: json['is_liked_by_me'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'user_name': userName,
    'user_image': userImage,
    'content': content,
    'commentable_type': commentableType,
    'commentable_id': commentableId,
    'likes_count': likesCount,
    'replies_count': repliesCount,
    'is_liked_by_me': isLikedByMe,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

/// Response wrapper for comments list
class CommentsResponse {
  final List<Comment> comments;
  final int total;
  final int page;
  final int perPage;

  CommentsResponse({
    required this.comments,
    required this.total,
    required this.page,
    required this.perPage,
  });

  factory CommentsResponse.fromJson(Map<String, dynamic> json) {
    return CommentsResponse(
      comments: (json['data'] as List?)
          ?.map((c) => Comment.fromJson(c as Map<String, dynamic>))
          .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      page: json['current_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 10,
    );
  }
}

/// Request to create/update a comment
class CreateCommentRequest {
  final String content;
  final String? commentableType;
  final int? commentableId;

  CreateCommentRequest({
    required this.content,
    this.commentableType,
    this.commentableId,
  });

  Map<String, dynamic> toJson() => {
    'content': content,
    if (commentableType != null) 'commentable_type': commentableType,
    if (commentableId != null) 'commentable_id': commentableId,
  };
}
