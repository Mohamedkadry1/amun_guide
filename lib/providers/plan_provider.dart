import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/plan_model.dart';
import '../data/services/plan_service.dart';
import '../data/services/api_client.dart';

class PlanProvider extends ChangeNotifier {
  final _service = PlanService();

  PlanModel? _currentPlan;
  bool _isLoading = false;
  String? _error;

  PlanModel? get currentPlan => _currentPlan;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadPlan(int id) async {
    _setLoading(true);
    _error = null;
    try {
      _currentPlan = await _service.getPlan(id);
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> savePlan(String title, List<Map<String, dynamic>> items) async {
    _setLoading(true);
    _error = null;
    try {
      _currentPlan = await _service.savePlan(title, items);
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleLike(int planId) async {
    try {
      await _service.toggleLike(planId);
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
      notifyListeners();
    }
  }
}
