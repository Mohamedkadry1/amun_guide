import 'dart:io';
import 'package:dio/dio.dart';
import '../models/payment_model.dart';
import 'api_client.dart';

class PaymentService {
  final _dio = ApiClient().dio;

  Future<List<PaymentModel>> getMyPayments() async {
    final res = await _dio.get('/api/v1/payments/my-payments');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => PaymentModel.fromJson(e)).toList();
  }

  Future<PaymentModel> uploadReceipt({
    required double amount,
    required String payableType,
    required int payableId,
    required File imageFile,
  }) async {
    final formData = FormData.fromMap({
      'amount': amount,
      'payable_type': payableType,
      'payable_id': payableId,
      'receipt_image': await MultipartFile.fromFile(imageFile.path),
    });

    final res = await _dio.post('/api/v1/payments', data: formData);
    final data = res.data['data'] ?? res.data;
    return PaymentModel.fromJson(data);
  }

  Future<PaymentModel> getPaymentDetails(int id) async {
    final res = await _dio.get('/api/v1/payments/$id');
    final data = res.data['data'] ?? res.data;
    return PaymentModel.fromJson(data);
  }
}
