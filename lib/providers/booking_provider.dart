import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/booking_model.dart';
import '../data/services/booking_service.dart';
import '../data/services/api_client.dart';

class BookingProvider extends ChangeNotifier {
  final _service = BookingService();

  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _error;

  List<BookingModel> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadMyBookings() async {
    _setLoading(true);
    _error = null;
    try {
      _bookings = await _service.getMyBookings();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> bookTour(int tourId, int participantsCount) async {
    _setLoading(true);
    _error = null;
    try {
      await _service.bookTour(tourId, participantsCount);
      return true;
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
