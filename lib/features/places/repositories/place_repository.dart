import 'package:amin_gide/core/services/api_service.dart';
import '../models/place_models.dart';
import '../models/review_models.dart';
import '../models/image_models.dart';

class PlaceRepository {
  final ApiService _apiService;

  PlaceRepository(this._apiService);

  // Build query string
  String _buildQueryString(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return '';
    final entries = params.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${e.value}');
    return entries.isEmpty ? '' : '?${entries.join('&')}';
  }

  // Get all places with pagination and filters
  Future<Map<String, dynamic>> getPlaces({
    int page = 1,
    int? categoryId,
    String? search,
    String? sortBy,
  }) async {
    try {
      final query = _buildQueryString({
        'page': page,
        'category_id': categoryId,
        'search': search,
        'sort_by': sortBy,
      });

      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/places$query',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load places');
      }

      return {
        'places': ((response.data!['data'] ?? []) as List)
            .map((p) => Place.fromJson(p as Map<String, dynamic>))
            .toList(),
        'pagination': response.data!['pagination'] ?? {},
      };
    } catch (e) {
      rethrow;
    }
  }

  // Get place details by ID
  Future<Place> getPlaceDetails(int placeId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/places/$placeId',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load place details');
      }

      return Place.fromJson(response.data!['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Get all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/categories',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load categories');
      }

      return ((response.data!['data'] ?? []) as List)
          .map((c) => Category.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get reviews for a place
  Future<List<Review>> getPlaceReviews(int placeId, {int page = 1}) async {
    try {
      final query = _buildQueryString({'page': page});
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/places/$placeId/reviews$query',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load reviews');
      }

      return ((response.data!['data'] ?? []) as List)
          .map((r) => Review.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Add review to place
  Future<Review> addReview(
    int placeId,
    String comment,
    int rating,
  ) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/places/$placeId/reviews',
        data: {
          'comment': comment,
          'rating': rating,
        },
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to add review');
      }

      return Review.fromJson(response.data!['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Get place images
  Future<List<PlaceImage>> getPlaceImages(int placeId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/places/$placeId/images',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load images');
      }

      return ((response.data!['data'] ?? []) as List)
          .map((i) => PlaceImage.fromJson(i as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Add to favorites
  Future<void> addToFavorites(int placeId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/places/$placeId/favorite',
        data: {},
        fromJson: (json) => json,
      );

      if (!response.success) {
        throw ApiException(message: 'Failed to add to favorites');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(int placeId) async {
    try {
      final response = await _apiService.delete<Map<String, dynamic>>(
        endpoint: '/places/$placeId/favorite',
        fromJson: (json) => json,
      );

      if (!response.success) {
        throw ApiException(message: 'Failed to remove from favorites');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get favorites list
  Future<List<Place>> getFavorites({int page = 1}) async {
    try {
      final query = _buildQueryString({'page': page});
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/places/favorites$query',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load favorites');
      }

      return ((response.data!['data'] ?? []) as List)
          .map((p) => Place.fromJson(p as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
