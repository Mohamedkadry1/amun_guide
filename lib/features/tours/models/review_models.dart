class TourReview {
  final int id;
  final int tourId;
  final int userId;
  final String userName;
  final String userImage;
  final String comment;
  final int rating; // 1-5
  final DateTime createdAt;
  final int helpfulCount;
  final bool isVerifiedBooking;

  TourReview({
    required this.id,
    required this.tourId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.rating,
    required this.createdAt,
    required this.helpfulCount,
    required this.isVerifiedBooking,
  });

  factory TourReview.fromJson(Map<String, dynamic> json) {
    return TourReview(
      id: json['id'] as int,
      tourId: json['tour_id'] as int,
      userId: json['user_id'] as int,
      userName: json['user_name'] as String,
      userImage: json['user_image'] as String? ?? '',
      comment: json['comment'] as String,
      rating: json['rating'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      helpfulCount: json['helpful_count'] as int? ?? 0,
      isVerifiedBooking: json['is_verified_booking'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tour_id': tourId,
        'user_id': userId,
        'user_name': userName,
        'user_image': userImage,
        'comment': comment,
        'rating': rating,
        'created_at': createdAt.toIso8601String(),
        'helpful_count': helpfulCount,
        'is_verified_booking': isVerifiedBooking,
      };
}

class TourRating {
  final int tourId;
  final int userId;
  final int rating;
  final DateTime createdAt;

  TourRating({
    required this.tourId,
    required this.userId,
    required this.rating,
    required this.createdAt,
  });

  factory TourRating.fromJson(Map<String, dynamic> json) {
    return TourRating(
      tourId: json['tour_id'] as int,
      userId: json['user_id'] as int,
      rating: json['rating'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'tour_id': tourId,
        'user_id': userId,
        'rating': rating,
        'created_at': createdAt.toIso8601String(),
      };
}

class RatingDistribution {
  final int totalReviews;
  final double averageRating;
  final int fiveStar;
  final int fourStar;
  final int threeStar;
  final int twoStar;
  final int oneStar;

  RatingDistribution({
    required this.totalReviews,
    required this.averageRating,
    required this.fiveStar,
    required this.fourStar,
    required this.threeStar,
    required this.twoStar,
    required this.oneStar,
  });

  factory RatingDistribution.fromJson(Map<String, dynamic> json) {
    return RatingDistribution(
      totalReviews: json['total_reviews'] as int,
      averageRating: (json['average_rating'] as num).toDouble(),
      fiveStar: json['five_star'] as int,
      fourStar: json['four_star'] as int,
      threeStar: json['three_star'] as int,
      twoStar: json['two_star'] as int,
      oneStar: json['one_star'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_reviews': totalReviews,
        'average_rating': averageRating,
        'five_star': fiveStar,
        'four_star': fourStar,
        'three_star': threeStar,
        'two_star': twoStar,
        'one_star': oneStar,
      };

  double getPercentage(int count) =>
      totalReviews > 0 ? (count / totalReviews) * 100 : 0;
}
