import 'package:flutter/material.dart';
import '../models/tour_models.dart';
import '../models/booking_models.dart';
import '../models/review_models.dart';
import '../repositories/tour_repository.dart';

class TourProvider extends ChangeNotifier {
  final TourRepository _repository;

  // State
  List<Tour> _tours = [];
  List<Tour> _favoriteTours = [];
  List<TourCategory> _categories = [];
  Tour? _selectedTour;
  List<Itinerary> _selectedTourItinerary = [];
  List<TourReview> _selectedTourReviews = [];
  RatingDistribution? _ratingDistribution;

  List<Booking> _myBookings = [];
  Booking? _selectedBooking;

  bool _isLoading = false;
  String? _errorMessage;

  int _currentPage = 1;
  bool _hasMorePages = true;

  // Getters
  List<Tour> get tours => _tours;
  List<Tour> get favoriteTours => _favoriteTours;
  List<TourCategory> get categories => _categories;
  Tour? get selectedTour => _selectedTour;
  List<Itinerary> get selectedTourItinerary => _selectedTourItinerary;
  List<TourReview> get selectedTourReviews => _selectedTourReviews;
  RatingDistribution? get ratingDistribution => _ratingDistribution;

  List<Booking> get myBookings => _myBookings;
  Booking? get selectedBooking => _selectedBooking;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMorePages => _hasMorePages;

  TourProvider(this._repository);

  // Load tours with pagination and filters
  Future<void> loadTours({
    String? category,
    String? difficulty,
    double? minPrice,
    double? maxPrice,
    String? search,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _repository.getTours(
        page: _currentPage,
        category: category,
        difficulty: difficulty,
        minPrice: minPrice,
        maxPrice: maxPrice,
        search: search,
      );

      final toursList = result['tours'] as List<Tour>? ?? [];
      if (_currentPage == 1) {
        _tours = toursList;
      } else {
        _tours.addAll(toursList);
      }

      final pagination = result['pagination'] as Map<String, dynamic>? ?? {};
      _hasMorePages = pagination['has_more'] as bool? ?? false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load next page
  Future<void> loadMoreTours({
    String? category,
    String? difficulty,
    double? minPrice,
    double? maxPrice,
    String? search,
  }) async {
    if (!_hasMorePages || _isLoading) return;

    _currentPage++;
    await loadTours(
      category: category,
      difficulty: difficulty,
      minPrice: minPrice,
      maxPrice: maxPrice,
      search: search,
    );
  }

  // Load tour details
  Future<void> loadTourDetails(int tourId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final tour = await _repository.getTourDetails(tourId);
      final itinerary = await _repository.getItinerary(tourId);
      final reviews = await _repository.getTourReviews(tourId: tourId);
      final rating = await _repository.getRatingDistribution(tourId);

      _selectedTour = tour;
      _selectedTourItinerary = itinerary;
      _selectedTourReviews = reviews['reviews'] as List<TourReview>? ?? [];
      _ratingDistribution = rating;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      _categories = await _repository.getCategories();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Load categories and tours on startup
  Future<void> loadInitialData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.wait([
        loadTours(),
        loadCategories(),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
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
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final confirmation = await _repository.createBooking(
        tourId: tourId,
        travelers: travelers,
        adults: adults,
        children: children,
        notes: notes,
      );

      _isLoading = false;
      notifyListeners();
      return confirmation;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Load my bookings
  Future<void> loadMyBookings({String? status}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _repository.getMyBookings(status: status);

      _myBookings = result['bookings'] as List<Booking>? ?? [];
      final pagination = result['pagination'] as Map<String, dynamic>? ?? {};
      _hasMorePages = pagination['has_more'] as bool? ?? false;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load booking details
  Future<void> loadBookingDetails(int bookingId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _selectedBooking = await _repository.getBookingDetails(bookingId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cancel booking
  Future<void> cancelBooking(int bookingId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.cancelBooking(bookingId);
      await loadMyBookings();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add tour review
  Future<void> addTourReview({
    required int tourId,
    required String comment,
    required int rating,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final newReview = await _repository.addTourReview(
        tourId: tourId,
        comment: comment,
        rating: rating,
      );

      _selectedTourReviews.insert(0, newReview);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add to favorite tours
  Future<void> addToFavoriteTours(int tourId) async {
    try {
      await _repository.addToFavoriteTours(tourId);

      // Update tour in list
      final tourIndex = _tours.indexWhere((t) => t.id == tourId);
      if (tourIndex != -1) {
        _tours[tourIndex] = Tour(
          id: _tours[tourIndex].id,
          name: _tours[tourIndex].name,
          description: _tours[tourIndex].description,
          startDate: _tours[tourIndex].startDate,
          endDate: _tours[tourIndex].endDate,
          price: _tours[tourIndex].price,
          rating: _tours[tourIndex].rating,
          reviewsCount: _tours[tourIndex].reviewsCount,
          imageUrl: _tours[tourIndex].imageUrl,
          imageGallery: _tours[tourIndex].imageGallery,
          itinerary: _tours[tourIndex].itinerary,
          maxCapacity: _tours[tourIndex].maxCapacity,
          currentCapacity: _tours[tourIndex].currentCapacity,
          guide: _tours[tourIndex].guide,
          pickupLocation: _tours[tourIndex].pickupLocation,
          category: _tours[tourIndex].category,
          amenities: _tours[tourIndex].amenities,
          isFavorite: true,
          tourType: _tours[tourIndex].tourType,
          difficulty: _tours[tourIndex].difficulty,
        );
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Remove from favorite tours
  Future<void> removeFromFavoriteTours(int tourId) async {
    try {
      await _repository.removeFromFavoriteTours(tourId);

      // Update tour in list
      final tourIndex = _tours.indexWhere((t) => t.id == tourId);
      if (tourIndex != -1) {
        _tours[tourIndex] = Tour(
          id: _tours[tourIndex].id,
          name: _tours[tourIndex].name,
          description: _tours[tourIndex].description,
          startDate: _tours[tourIndex].startDate,
          endDate: _tours[tourIndex].endDate,
          price: _tours[tourIndex].price,
          rating: _tours[tourIndex].rating,
          reviewsCount: _tours[tourIndex].reviewsCount,
          imageUrl: _tours[tourIndex].imageUrl,
          imageGallery: _tours[tourIndex].imageGallery,
          itinerary: _tours[tourIndex].itinerary,
          maxCapacity: _tours[tourIndex].maxCapacity,
          currentCapacity: _tours[tourIndex].currentCapacity,
          guide: _tours[tourIndex].guide,
          pickupLocation: _tours[tourIndex].pickupLocation,
          category: _tours[tourIndex].category,
          amenities: _tours[tourIndex].amenities,
          isFavorite: false,
          tourType: _tours[tourIndex].tourType,
          difficulty: _tours[tourIndex].difficulty,
        );
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Load favorite tours
  Future<void> loadFavoriteTours() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _repository.getFavoriteTours();

      _favoriteTours = result['tours'] as List<Tour>? ?? [];
      final pagination = result['pagination'] as Map<String, dynamic>? ?? {};
      _hasMorePages = pagination['has_more'] as bool? ?? false;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Set mock tour when API fails
  void setSelectedTourMock(Tour mockTour) {
    _selectedTour = mockTour;
    _selectedTourItinerary = [
      Itinerary(
        day: 1,
        title: 'Arrival and Temple Visit',
        location: 'Karnak Temple',
        description: 'Arrive in Luxor and begin with the magnificent Karnak Temple complex.',
        activities: ['Welcome briefing', 'Temple tour', 'Photography', 'Dinner'],
      ),
      Itinerary(
        day: 2,
        title: 'Valley of the Kings',
        location: 'Valley of the Kings',
        description: 'Explore the royal tombs in the Valley of the Kings.',
        activities: ['Tomb visits', 'Photography', 'Lunch', 'Local market'],
      ),
      Itinerary(
        day: 3,
        title: 'Nile Cruise and Farewell',
        location: 'Nile River',
        description: 'Enjoy a relaxing Nile river cruise and visit local temples.',
        activities: ['Nile cruise', 'Temple visit', 'Sunset', 'Farewell dinner'],
      ),
    ];
    _errorMessage = null;
    notifyListeners();
  }

  // Reset pagination
  void resetPagination() {
    _currentPage = 1;
    _hasMorePages = true;
  }
}
