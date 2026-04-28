// Image Model
class PlaceImage {
  final int id;
  final int placeId;
  final String url;
  final bool isPrimary;

  PlaceImage({
    required this.id,
    required this.placeId,
    required this.url,
    required this.isPrimary,
  });

  factory PlaceImage.fromJson(Map<String, dynamic> json) {
    return PlaceImage(
      id: json['id'] as int,
      placeId: json['place_id'] as int,
      url: json['url'] as String,
      isPrimary: json['is_primary'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'place_id': placeId,
    'url': url,
    'is_primary': isPrimary,
  };
}
