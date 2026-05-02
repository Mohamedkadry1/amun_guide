import '../models/tour_model.dart';
import 'api_client.dart';

class TourService {
  final _dio = ApiClient().dio;

  Future<List<TourModel>> getAllTours({int page = 1, int perPage = 10}) async {
    final res = await _dio.get('/api/v1/tours',
        queryParameters: {'page': page, 'per_page': perPage});
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => TourModel.fromJson(e)).toList();
  }

  Future<List<TourModel>> getPopularTours() async {
    final res = await _dio.get('/api/v1/tours/popular');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => TourModel.fromJson(e)).toList();
  }

  Future<List<TourModel>> searchTours(String q) async {
    final res =
        await _dio.get('/api/v1/tours/search', queryParameters: {'q': q});
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => TourModel.fromJson(e)).toList();
  }

  Future<List<TourModel>> filterTours(
      {double? minPrice, double? maxPrice}) async {
    final params = <String, dynamic>{};
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    final res =
        await _dio.get('/api/v1/tours/filter', queryParameters: params);
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => TourModel.fromJson(e)).toList();
  }

  Future<TourModel> getTour(int id) async {
    final res = await _dio.get('/api/v1/tours/$id');
    final data = res.data['data'] ?? res.data;
    return TourModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> toggleLike(int tourId) async {
    await _dio.post('/api/v1/likes/toggle', data: {
      'likeable_type': 'tours',
      'likeable_id': tourId,
    });
  }
}
