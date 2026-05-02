import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/tour_model.dart';
import '../data/services/tour_service.dart';
import '../data/services/api_client.dart';

class TourProvider extends ChangeNotifier {
  final _service = TourService();

  List<TourModel> _tours = [];
  List<TourModel> _popular = [];
  bool _isLoading = false;
  String? _error;

  List<TourModel> get tours => _tours;
  List<TourModel> get popular => _popular;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadAllTours() async {
    _setLoading(true);
    _error = null;
    try {
      _tours = await _service.getAllTours();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadPopular() async {
    _setLoading(true);
    _error = null;
    try {
      _popular = await _service.getPopularTours();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> search(String q) async {
    if (q.trim().isEmpty) {
      await loadAllTours();
      return;
    }
    _setLoading(true);
    _error = null;
    try {
      _tours = await _service.searchTours(q);
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleLike(int tourId) async {
    try {
      await _service.toggleLike(tourId);
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
      notifyListeners();
    }
  }
}
