import 'package:flutter/material.dart';
import '../models/place_models.dart';
import '../models/review_models.dart';
import '../models/image_models.dart';
import '../repositories/place_repository.dart';

class PlaceProvider extends ChangeNotifier {
  final PlaceRepository _repository;

  // State
  List<Place> _places = [];
  List<Place> _favorites = [];
  List<Category> _categories = [];
  Place? _selectedPlace;
  List<Review> _selectedPlaceReviews = [];
  List<PlaceImage> _selectedPlaceImages = [];

  bool _isLoading = false;
  String? _errorMessage;

  int _currentPage = 1;
  bool _hasMorePages = true;

  // Getters
  List<Place> get places => _places;
  List<Place> get favorites => _favorites;
  List<Category> get categories => _categories;
  Place? get selectedPlace => _selectedPlace;
  List<Review> get selectedPlaceReviews => _selectedPlaceReviews;
  List<PlaceImage> get selectedPlaceImages => _selectedPlaceImages;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMorePages => _hasMorePages;

  PlaceProvider(this._repository);

  // Load initial data
  Future<void> loadInitialData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Load places and categories
      await Future.wait([
        loadPlaces(),
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

  // Load places with pagination
  Future<void> loadPlaces({
    int categoryId = 0,
    String? search,
    String? sortBy,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await _repository.getPlaces(
        page: _currentPage,
        categoryId: categoryId != 0 ? categoryId : null,
        search: search,
        sortBy: sortBy,
      );

      final placesList = result['places'] as List<Place>? ?? [];
      if (_currentPage == 1) {
        _places = placesList;
      } else {
        _places.addAll(placesList);
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
  Future<void> loadMorePlaces({
    int categoryId = 0,
    String? search,
  }) async {
    if (!_hasMorePages || _isLoading) return;

    _currentPage++;
    await loadPlaces(
      categoryId: categoryId,
      search: search,
    );
  }

  // Load place details
  Future<void> loadPlaceDetails(int placeId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final place = await _repository.getPlaceDetails(placeId);
      final reviews = await _repository.getPlaceReviews(placeId);
      final images = await _repository.getPlaceImages(placeId);

      _selectedPlace = place;
      _selectedPlaceReviews = reviews;
      _selectedPlaceImages = images;

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

  // Add review
  Future<void> addReview(String comment, int rating) async {
    if (_selectedPlace == null) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final review = await _repository.addReview(
        _selectedPlace!.id,
        comment,
        rating,
      );

      _selectedPlaceReviews.insert(0, review);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to favorites
  Future<void> addToFavorites(int placeId) async {
    try {
      await _repository.addToFavorites(placeId);

      // Update place in list
      final index = _places.indexWhere((p) => p.id == placeId);
      if (index != -1) {
        final place = _places[index];
        _places[index] = Place(
          id: place.id,
          name: place.name,
          description: place.description,
          imageUrl: place.imageUrl,
          imageGallery: place.imageGallery,
          price: place.price,
          rating: place.rating,
          reviewsCount: place.reviewsCount,
          location: place.location,
          latitude: place.latitude,
          longitude: place.longitude,
          categoryId: place.categoryId,
          amenities: place.amenities,
          isFavorite: true,
          createdAt: place.createdAt,
        );
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(int placeId) async {
    try {
      await _repository.removeFromFavorites(placeId);

      // Update place in list
      final index = _places.indexWhere((p) => p.id == placeId);
      if (index != -1) {
        final place = _places[index];
        _places[index] = Place(
          id: place.id,
          name: place.name,
          description: place.description,
          imageUrl: place.imageUrl,
          imageGallery: place.imageGallery,
          price: place.price,
          rating: place.rating,
          reviewsCount: place.reviewsCount,
          location: place.location,
          latitude: place.latitude,
          longitude: place.longitude,
          categoryId: place.categoryId,
          amenities: place.amenities,
          isFavorite: false,
          createdAt: place.createdAt,
        );
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Load favorites
  Future<void> loadFavorites() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _favorites = await _repository.getFavorites();
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

  // Reset pagination
  void resetPagination() {
    _currentPage = 1;
    _hasMorePages = true;
  }
}
