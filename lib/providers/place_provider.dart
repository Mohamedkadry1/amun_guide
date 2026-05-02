import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../data/models/comment_model.dart';
import '../data/models/place_model.dart';

import '../data/services/place_service.dart';
import '../data/services/api_client.dart';

class PlaceProvider extends ChangeNotifier {
  final _service = PlaceService();

  List<PlaceModel> _places = [];
  List<PlaceModel> _trending = [];
  List<PlaceModel> _likedPlaces = [];
  List<CommentModel> _comments = [];
  bool _isLoading = false;
  String? _error;

  List<PlaceModel> get places => _places;
  List<PlaceModel> get trending => _trending;
  List<PlaceModel> get likedPlaces => _likedPlaces;
  List<CommentModel> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> loadAllPlaces() async {
    _setLoading(true);
    _error = null;
    try {
      _places = await _service.getAllPlaces();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTrending() async {
    _setLoading(true);
    _error = null;
    try {
      _trending = await _service.getTrendingPlaces();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> search(String q) async {
    if (q.trim().isEmpty) {
      await loadAllPlaces();
      return;
    }
    _setLoading(true);
    _error = null;
    try {
      _places = await _service.searchPlaces(q);
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadLikedPlaces() async {
    _setLoading(true);
    _error = null;
    try {
      _likedPlaces = await _service.getUserLikes();
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadComments(int placeId) async {
    _setLoading(true);
    _error = null;
    try {
      _comments = await _service.getComments(placeId);
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addComment(int placeId, String content) async {
    _error = null;
    try {
      await _service.addComment(placeId, content);
      await loadComments(placeId);
      return true;
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> toggleLike(int placeId) async {
    try {
      await _service.toggleLike(placeId);
    } on DioException catch (e) {
      _error = ApiClient.parseError(e);
      notifyListeners();
    }
  }
}
