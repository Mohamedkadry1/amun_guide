import 'dart:io';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';
import '../data/services/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final _service = AuthService();

  UserModel? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _token != null;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final data = await _service.login(email: email, password: password);
      _token = _service.parseToken(data);
      _user = _service.parseUser(data);
      await _saveToken(_token!);
      _setLoading(false);
      return true;
    } on DioException catch (e) {
      _setError(ApiClient.parseError(e));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    String? profileImagePath,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final data = await _service.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        profileImagePath: profileImagePath,
      );
      _token = _service.parseToken(data);
      _user = _service.parseUser(data);
      await _saveToken(_token!);
      _setLoading(false);
      return true;
    } on DioException catch (e) {
      _setError(ApiClient.parseError(e));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.forgotPassword(email);
      _setLoading(false);
      return true;
    } on DioException catch (e) {
      _setError(ApiClient.parseError(e));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.resetPassword(
        token: token,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      _setLoading(false);
      return true;
    } on DioException catch (e) {
      _setError(ApiClient.parseError(e));
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateProfile({String? name, String? email, File? avatar}) async {
    _setLoading(true);
    _setError(null);
    try {
      _user = await _service.updateProfile(name: name, email: email, avatar: avatar);
      _setLoading(false);
      return true;
    } on DioException catch (e) {
      _setError(ApiClient.parseError(e));
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('auth_token');
    if (saved == null) return false;
    _token = saved;
    notifyListeners();
    return true;
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}
