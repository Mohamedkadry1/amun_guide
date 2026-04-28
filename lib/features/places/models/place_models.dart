// Place Model
class Place {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String>? imageGallery;
  final double price;
  final double rating;
  final int reviewsCount;
  final String location;
  final double latitude;
  final double longitude;
  final int categoryId;
  final List<String>? amenities;
  final bool isFavorite;
  final DateTime createdAt;

  Place({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.imageGallery,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.categoryId,
    this.amenities,
    this.isFavorite = false,
    required this.createdAt,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      imageGallery: List<String>.from(
        (json['image_gallery'] as List?) ?? [],
      ),
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviews_count'] as int? ?? 0,
      location: json['location'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      categoryId: json['category_id'] as int,
      amenities: List<String>.from(
        (json['amenities'] as List?) ?? [],
      ),
      isFavorite: json['is_favorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image_url': imageUrl,
    'image_gallery': imageGallery,
    'price': price,
    'rating': rating,
    'reviews_count': reviewsCount,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'category_id': categoryId,
    'amenities': amenities,
    'is_favorite': isFavorite,
    'created_at': createdAt.toIso8601String(),
  };
}

// Category Model
class Category {
  final int id;
  final String name;
  final String? icon;
  final String? description;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'description': description,
  };
}
