class PlaceModel {
  final int id;
  final String title;
  final String description;
  final double ticketPrice;
  final double rating;
  final String? image;

  const PlaceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ticketPrice,
    required this.rating,
    this.image,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      ticketPrice: (json['ticket_price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      image: json['image'],
    );
  }

  String get displayPrice => '\$${ticketPrice.toStringAsFixed(0)}/pax';
  String get displayRating => rating.toStringAsFixed(1);
}
