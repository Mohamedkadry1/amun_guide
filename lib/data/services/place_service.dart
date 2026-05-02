import '../models/comment_model.dart';
import '../models/place_model.dart';

import 'api_client.dart';

class PlaceService {
  final _dio = ApiClient().dio;

  Future<List<PlaceModel>> getAllPlaces() async {
    final res = await _dio.get('/api/v1/places');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => PlaceModel.fromJson(e)).toList();
  }

  Future<List<PlaceModel>> getTrendingPlaces() async {
    final res = await _dio.get('/api/v1/places/trending');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => PlaceModel.fromJson(e)).toList();
  }

  Future<List<PlaceModel>> searchPlaces(String q) async {
    final res = await _dio.get('/api/v1/places/search', queryParameters: {'q': q});
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => PlaceModel.fromJson(e)).toList();
  }

  Future<List<PlaceModel>> filterPlaces({double? minPrice, double? maxPrice}) async {
    final params = <String, dynamic>{};
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    final res = await _dio.get('/api/v1/places/filter', queryParameters: params);
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => PlaceModel.fromJson(e)).toList();
  }

  Future<PlaceModel> getPlace(int id) async {
    final res = await _dio.get('/api/v1/places/$id');
    final data = res.data['data'] ?? res.data;
    return PlaceModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<CommentModel>> getComments(int placeId) async {
    final res = await _dio.get('/api/v1/places/$placeId/comments');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => CommentModel.fromJson(e)).toList();
  }

  Future<void> addComment(int placeId, String content) async {
    await _dio.post('/api/v1/places/$placeId/comments', data: {'content': content});
  }

  Future<void> toggleLike(int placeId) async {
    await _dio.post('/api/v1/likes/toggle', data: {
      'likeable_type': 'places',
      'likeable_id': placeId,
    });
  }

  Future<List<PlaceModel>> getUserLikes() async {
    final res = await _dio.get('/api/v1/user/likes');
    final data = res.data['data'] ?? res.data;
    return (data as List).map((e) => PlaceModel.fromJson(e)).toList();
  }
}
