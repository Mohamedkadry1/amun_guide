import 'package:amin_gide/core/services/api_service.dart';
import '../models/tour_models.dart';
import '../models/booking_models.dart';
import '../models/review_models.dart';

class TourRepository {
  final ApiService _apiService;

  TourRepository(this._apiService);

  // Build query string
  String _buildQueryString(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return '';
    final entries = params.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${e.value}');
    return entries.isEmpty ? '' : '?${entries.join('&')}';
  }

  // Get all tours with pagination and filters
  Future<Map<String, dynamic>> getTours({
    int page = 1,
    String? category,
    String? difficulty,
    double? minPrice,
    double? maxPrice,
    String? search,
  }) async {
    try {
      final query = _buildQueryString({
        'page': page,
        'category': category,
        'difficulty': difficulty,
        'min_price': minPrice,
        'max_price': maxPrice,
        'search': search,
      });

      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/tours$query',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load tours');
      }

      return {
        'tours': ((response.data!['data'] ?? []) as List)
            .map((t) => Tour.fromJson(t as Map<String, dynamic>))
            .toList(),
        'pagination': response.data!['pagination'] ?? {},
      };
    } catch (e) {
      rethrow;
    }
  }

  // Get tour details by ID
  Future<Tour> getTourDetails(int tourId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/tours/$tourId',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load tour details');
      }

      return Tour.fromJson(response.data!['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Get tour itinerary
  Future<List<Itinerary>> getItinerary(int tourId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/tours/$tourId/itinerary',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load itinerary');
      }

      return ((response.data!['data'] ?? []) as List)
          .map((i) => Itinerary.fromJson(i as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get tour categories
  Future<List<TourCategory>> getCategories() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/tours/categories',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load categories');
      }

      return ((response.data!['data'] ?? []) as List)
          .map((c) => TourCategory.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Create booking
  Future<BookingConfirmation> createBooking({
    required int tourId,
    required List<Map<String, dynamic>> travelers,
    required int adults,
    required int children,
    String? notes,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/bookings',
        data: {
          'tour_id': tourId,
          'travelers': travelers,
          'adults': adults,
          'children': children,
          'notes': notes,
        },
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to create booking');
      }

      return BookingConfirmation.fromJson(
          response.data!['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Get my bookings
  Future<Map<String, dynamic>> getMyBookings({
    int page = 1,
    String? status,
  }) async {
    try {
      final query = _buildQueryString({
        'page': page,
        'status': status,
      });

      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/bookings$query',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load bookings');
      }

      return {
        'bookings': ((response.data!['data'] ?? []) as List)
            .map((b) => Booking.fromJson(b as Map<String, dynamic>))
            .toList(),
        'pagination': response.data!['pagination'] ?? {},
      };
    } catch (e) {
      rethrow;
    }
  }

  // Get booking details
  Future<Booking> getBookingDetails(int bookingId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/bookings/$bookingId',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load booking details');
      }

      return Booking.fromJson(response.data!['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Cancel booking
  Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    try {
      final response = await _apiService.delete<Map<String, dynamic>>(
        endpoint: '/bookings/$bookingId',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to cancel booking');
      }

      return response.data!['data'] as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Get tour reviews
  Future<Map<String, dynamic>> getTourReviews({
    required int tourId,
    int page = 1,
    String? sortBy,
  }) async {
    try {
      final query = _buildQueryString({
        'page': page,
        'sort_by': sortBy,
      });

      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/tours/$tourId/reviews$query',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load reviews');
      }

      return {
        'reviews': ((response.data!['data'] ?? []) as List)
            .map((r) => TourReview.fromJson(r as Map<String, dynamic>))
            .toList(),
        'pagination': response.data!['pagination'] ?? {},
      };
    } catch (e) {
      rethrow;
    }
  }

  // Get rating distribution
  Future<RatingDistribution> getRatingDistribution(int tourId) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/tours/$tourId/rating-distribution',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load rating distribution');
      }

      return RatingDistribution.fromJson(
          response.data!['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Add tour review
  Future<TourReview> addTourReview({
    required int tourId,
    required String comment,
    required int rating,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/tours/$tourId/reviews',
        data: {
          'comment': comment,
          'rating': rating,
        },
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to add review');
      }

      return TourReview.fromJson(response.data!['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Add to favorites
  Future<Map<String, dynamic>> addToFavoriteTours(int tourId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/tours/$tourId/favorite',
        data: {},
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to add to favorites');
      }

      return response.data!['data'] as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Remove from favorites
  Future<Map<String, dynamic>> removeFromFavoriteTours(int tourId) async {
    try {
      final response = await _apiService.delete<Map<String, dynamic>>(
        endpoint: '/tours/$tourId/favorite',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to remove from favorites');
      }

      return response.data!['data'] as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Get favorite tours
  Future<Map<String, dynamic>> getFavoriteTours({int page = 1}) async {
    try {
      final query = _buildQueryString({'page': page});

      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/tours/favorites$query',
        fromJson: (json) => json,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: 'Failed to load favorite tours');
      }

      return {
        'tours': ((response.data!['data'] ?? []) as List)
            .map((t) => Tour.fromJson(t as Map<String, dynamic>))
            .toList(),
        'pagination': response.data!['pagination'] ?? {},
      };
    } catch (e) {
      rethrow;
    }
  }
}
