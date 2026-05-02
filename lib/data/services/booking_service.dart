import '../models/booking_model.dart';
import 'api_client.dart';

class BookingService {
  final _dio = ApiClient().dio;

  Future<void> bookTour(int tourId, int participantsCount) async {
    await _dio.post('/api/v1/tour-bookings', data: {
      'tour_id': tourId,
      'participants_count': participantsCount,
    });
  }

  Future<List<BookingModel>> getMyBookings() async {
    final res = await _dio.get('/api/v1/tour-bookings/my-bookings');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => BookingModel.fromJson(e)).toList();
  }
}
