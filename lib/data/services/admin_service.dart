import 'dart:io';
import 'package:dio/dio.dart';
import '../models/tour_model.dart';
import '../models/booking_model.dart';
import '../models/payment_model.dart';
import 'api_client.dart';

class AdminService {
  final _dio = ApiClient().dio;

  // Stats — aggregate from payment + booking statistics
  Future<Map<String, dynamic>> getStats() async {
    final results = await Future.wait([
      _dio.get('/api/v1/payments/statistics'),
      _dio.get('/api/v1/tour-bookings/statistics'),
    ]);
    final payStats = results[0].data['data'] ?? results[0].data ?? {};
    final bookStats = results[1].data['data'] ?? results[1].data ?? {};
    return {...payStats, ...bookStats};
  }

  // Tours
  Future<List<TourModel>> getAllTours() async {
    final res = await _dio.get('/api/v1/tours');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => TourModel.fromJson(e)).toList();
  }

  Future<void> createTour(Map<String, dynamic> data, File? image) async {
    final formData = FormData.fromMap({
      ...data,
      if (image != null) 'cover_image': await MultipartFile.fromFile(image.path),
    });
    await _dio.post('/api/v1/tours', data: formData);
  }

  Future<void> deleteTour(int id) async {
    await _dio.delete('/api/v1/tours/$id');
  }

  // Bookings
  Future<List<BookingModel>> getAllBookings() async {
    final res = await _dio.get('/api/v1/tour-bookings');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => BookingModel.fromJson(e)).toList();
  }

  Future<void> approveBooking(int id) async {
    await _dio.post('/api/v1/tour-bookings/$id/approve');
  }

  Future<void> rejectBooking(int id) async {
    await _dio.post('/api/v1/tour-bookings/$id/reject');
  }

  // Payments
  Future<List<PaymentModel>> getAllPayments() async {
    final res = await _dio.get('/api/v1/payments');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => PaymentModel.fromJson(e)).toList();
  }

  Future<void> approvePayment(int id) async {
    await _dio.post('/api/v1/payments/$id/approve');
  }

  Future<void> rejectPayment(int id) async {
    await _dio.post('/api/v1/payments/$id/reject');
  }

  // Users (admin only)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final res = await _dio.get('/api/v1/analysis/users-all');
    final data = res.data['data'] ?? res.data;
    return (data as List).cast<Map<String, dynamic>>();
  }
}
