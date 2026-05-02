import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/payment_model.dart';
import '../data/services/payment_service.dart';
import '../data/services/api_client.dart';

class PaymentProvider extends ChangeNotifier {
  final _service = PaymentService();

  List<PaymentModel> _payments = [];
  bool _isLoading = false;
  String? _error;

  List<PaymentModel> get payments => _payments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadMyPayments() async {
    _setLoading(true);
    _error = null;
    try {
      _payments = await _service.getMyPayments();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> uploadReceipt({
    required double amount,
    required String payableType,
    required int payableId,
    required File imageFile,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      await _service.uploadReceipt(
        amount: amount,
        payableType: payableType,
        payableId: payableId,
        imageFile: imageFile,
      );
      await loadMyPayments();
      return true;
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
