import '../models/notification_model.dart';
import 'api_client.dart';

class NotificationService {
  final _dio = ApiClient().dio;

  Future<List<NotificationModel>> getNotifications() async {
    final res = await _dio.get('/api/v1/notifications');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<void> markAsRead(int id) async {
    await _dio.post('/api/v1/notifications/$id/mark-as-read');
  }
}
