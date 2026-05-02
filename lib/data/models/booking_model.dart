import 'tour_model.dart';

class BookingModel {
  final int id;
  final int tourId;
  final int participantsCount;
  final String status;
  final String? createdAt;
  final TourModel? tour;

  BookingModel({
    required this.id,
    required this.tourId,
    required this.participantsCount,
    required this.status,
    this.createdAt,
    this.tour,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? 0,
      tourId: json['tour_id'] ?? 0,
      participantsCount: json['participants_count'] ?? 0,
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'],
      tour: json['tour'] != null ? TourModel.fromJson(json['tour']) : null,
    );
  }
}
