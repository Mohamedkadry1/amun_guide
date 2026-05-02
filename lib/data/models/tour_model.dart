class TourModel {
  final int id;
  final String title;
  final double price;
  final String? startDate;
  final String? startTime;
  final String? details;
  final String? paymentMethod;
  final double? rating;
  final List<dynamic> places;

  const TourModel({
    required this.id,
    required this.title,
    required this.price,
    this.startDate,
    this.startTime,
    this.details,
    this.paymentMethod,
    this.rating,
    this.places = const [],
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      startDate: json['start_date'],
      startTime: json['start_time'],
      details: json['details'],
      paymentMethod: json['payment_method'],
      rating: json['rating'] != null ? (json['rating']).toDouble() : null,
      places: json['places'] ?? [],
    );
  }

  String get displayPrice => '\$${price.toStringAsFixed(0)}/pax';
  String get displayRating =>
      rating != null ? rating!.toStringAsFixed(1) : '—';

  // صورة أول مكان في الجولة لو موجودة
  String? get coverImage {
    if (places.isEmpty) return null;
    final first = places.first;
    if (first is Map) return first['image'] as String?;
    return null;
  }

  // موقع أول مكان
  String get location {
    if (places.isEmpty) return 'Egypt';
    final first = places.first;
    if (first is Map) return first['title']?.toString() ?? 'Egypt';
    return 'Egypt';
  }
}
