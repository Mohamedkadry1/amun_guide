// Review Model
class Review {
  final int id;
  final int placeId;
  final int userId;
  final String userName;
  final String userImage;
  final String comment;
  final int rating;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      placeId: json['place_id'] as int,
      userId: json['user_id'] as int,
      userName: json['user_name'] as String,
      userImage: json['user_image'] as String,
      comment: json['comment'] as String,
      rating: json['rating'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'place_id': placeId,
    'user_id': userId,
    'user_name': userName,
    'user_image': userImage,
    'comment': comment,
    'rating': rating,
    'created_at': createdAt.toIso8601String(),
  };
}

// Rating Model
class Rating {
  final int placeId;
  final int userId;
  final int rating;
  final DateTime createdAt;

  Rating({
    required this.placeId,
    required this.userId,
    required this.rating,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      placeId: json['place_id'] as int,
      userId: json['user_id'] as int,
      rating: json['rating'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'place_id': placeId,
    'user_id': userId,
    'rating': rating,
    'created_at': createdAt.toIso8601String(),
  };
}
