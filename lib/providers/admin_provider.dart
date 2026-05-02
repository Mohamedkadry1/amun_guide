import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/tour_model.dart';
import '../data/models/booking_model.dart';
import '../data/models/payment_model.dart';
import '../data/services/admin_service.dart';
import '../data/services/api_client.dart';

class AdminProvider extends ChangeNotifier {
  final _service = AdminService();

  bool _isLoading = false;
  String? _error;
  
  Map<String, dynamic> _stats = {};
  List<TourModel> _tours = [];
  List<BookingModel> _bookings = [];
  List<PaymentModel> _payments = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic> get stats => _stats;
  List<TourModel> get tours => _tours;
  List<BookingModel> get bookings => _bookings;
  List<PaymentModel> get payments => _payments;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadStats() async {
    _setLoading(true);
    try {
      _stats = await _service.getStats();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTours() async {
    _setLoading(true);
    try {
      _tours = await _service.getAllTours();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadBookings() async {
    _setLoading(true);
    try {
      _bookings = await _service.getAllBookings();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadPayments() async {
    _setLoading(true);
    try {
      _payments = await _service.getAllPayments();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updatePayment(int id, String status) async {
    try {
      if (status.toLowerCase() == 'approved') {
        await _service.approvePayment(id);
      } else {
        await _service.rejectPayment(id);
      }
      await loadPayments();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateBooking(int id, String status) async {
    try {
      if (status.toLowerCase() == 'approved') {
        await _service.approveBooking(id);
      } else {
        await _service.rejectBooking(id);
      }
      await loadBookings();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> createTour(Map<String, dynamic> data, File? image) async {
    _setLoading(true);
    try {
      await _service.createTour(data, image);
      await loadTours();
      return true;
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
