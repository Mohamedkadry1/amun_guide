import 'dart:io';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'api_client.dart';

class AuthService {
  final _dio = ApiClient().dio;

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/api/login',
      data: {'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    String? profileImagePath,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      if (profileImagePath != null)
        'profile_image': await MultipartFile.fromFile(profileImagePath),
    });

    final response = await _dio.post('/api/register', data: formData);
    return response.data as Map<String, dynamic>;
  }

  Future<void> forgotPassword(String email) async {
    await _dio.post(
      '/api/forgot-password',
      data: {'email': email},
    );
  }

  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    await _dio.post(
      '/api/reset-password',
      queryParameters: {
        'token': token,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  UserModel parseUser(Map<String, dynamic> data) {
    final userJson = data['user'] ?? data['data'] ?? data;
    return UserModel.fromJson(userJson as Map<String, dynamic>);
  }

  String parseToken(Map<String, dynamic> data) {
    return (data['token'] ?? data['access_token'] ?? '').toString();
  }

  Future<UserModel> updateProfile({String? name, String? email, File? avatar}) async {
    final formData = FormData.fromMap({
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (avatar != null) 'avatar': await MultipartFile.fromFile(avatar.path),
    });
    final res = await _dio.post('/api/v1/auth/update-profile', data: formData);
    final data = res.data['data'] ?? res.data;
    return UserModel.fromJson(data);
  }
}
