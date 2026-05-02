import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/notification_model.dart';
import '../data/services/notification_service.dart';
import '../data/services/api_client.dart';

class NotificationProvider extends ChangeNotifier {
  final _service = NotificationService();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadNotifications() async {
    _setLoading(true);
    _error = null;
    try {
      _notifications = await _service.getNotifications();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> markRead(int id) async {
    try {
      await _service.markAsRead(id);
      final idx = _notifications.indexWhere((n) => n.id == id);
      if (idx != -1) {
        // Normally we'd update the local state or reload
        loadNotifications(); 
      }
    } catch (e) {
      // Ignore
    }
  }
}
