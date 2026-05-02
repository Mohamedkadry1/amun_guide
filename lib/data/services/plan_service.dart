import '../models/plan_model.dart';
import 'api_client.dart';

class PlanService {
  final _dio = ApiClient().dio;

  Future<PlanModel> getPlan(int id) async {
    final res = await _dio.get('/api/plans/$id');
    final data = res.data['data'] ?? res.data;
    return PlanModel.fromJson(data);
  }

  Future<PlanModel> savePlan(String title, List<Map<String, dynamic>> items) async {
    final res = await _dio.post('/api/plans', data: {
      'title': title,
      'plan_items': items,
    });
    final data = res.data['data'] ?? res.data;
    return PlanModel.fromJson(data);
  }

  Future<void> toggleLike(int planId) async {
    await _dio.post('/api/v1/likes/toggle', data: {
      'likeable_type': 'plans',
      'likeable_id': planId,
    });
  }
}
