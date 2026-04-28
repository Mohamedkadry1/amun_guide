import 'package:flutter/material.dart';
import '../models/comment_models.dart';
import '../repositories/comment_repository.dart';

class CommentProvider extends ChangeNotifier {
  final CommentRepository _repository;

  CommentProvider(this._repository);

  // State
  List<Comment> _comments = [];
  int _commentsPage = 1;
  final int _commentsPerPage = 20;
  int _totalComments = 0;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasMore = true;

  // Getters
  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  int get totalComments => _totalComments;

  /// Load comments for a specific resource (place, tour, plan)
  Future<void> loadComments({
    required String type,
    required int resourceId,
    bool reset = true,
  }) async {
    if (reset) {
      _comments = [];
      _commentsPage = 1;
      _hasMore = true;
    }

    if (!hasMore && !reset) {
      return; // No more pages to load
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.getComments(
        type: type,
        resourceId: resourceId,
        page: _commentsPage,
        perPage: _commentsPerPage,
      );

      _comments.addAll(response.comments);
      _totalComments = response.total;
      _commentsPage++;
      
      // Check if there are more pages
      _hasMore = (_commentsPage - 1) * _commentsPerPage < _totalComments;

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _comments = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load more comments (pagination)
  Future<void> loadMoreComments({
    required String type,
    required int resourceId,
  }) async {
    if (!_hasMore || _isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.getComments(
        type: type,
        resourceId: resourceId,
        page: _commentsPage,
        perPage: _commentsPerPage,
      );

      _comments.addAll(response.comments);
      _commentsPage++;
      
      _hasMore = (_commentsPage - 1) * _commentsPerPage < _totalComments;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Create a new comment
  Future<void> createComment({
    required String content,
    required String commentableType,
    required int commentableId,
  }) async {
    try {
      final newComment = await _repository.createComment(
        content: content,
        commentableType: commentableType,
        commentableId: commentableId,
      );

      // Add new comment to the beginning of the list
      _comments.insert(0, newComment);
      _totalComments++;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Update a comment
  Future<void> updateComment({
    required int commentId,
    required String content,
  }) async {
    try {
      final updatedComment = await _repository.updateComment(
        commentId: commentId,
        content: content,
      );

      // Update the comment in the list
      final index = _comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        _comments[index] = updatedComment;
      }

      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Delete a comment
  Future<void> deleteComment(int commentId) async {
    try {
      await _repository.deleteComment(commentId);

      // Remove comment from list
      _comments.removeWhere((c) => c.id == commentId);
      _totalComments = (_totalComments - 1).clamp(0, double.infinity).toInt();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Get comment count for a resource
  Future<int> getCommentCount({
    required String type,
    required int resourceId,
  }) async {
    try {
      return await _repository.getCommentCount(
        type: type,
        resourceId: resourceId,
      );
    } catch (e) {
      _errorMessage = e.toString();
      return 0;
    }
  }

  /// Like a comment
  Future<void> likeComment(int commentId) async {
    try {
      await _repository.likeComment(commentId);

      // Update the comment
      final index = _comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        final comment = _comments[index];
        _comments[index] = Comment(
          id: comment.id,
          userId: comment.userId,
          userName: comment.userName,
          userImage: comment.userImage,
          content: comment.content,
          commentableType: comment.commentableType,
          commentableId: comment.commentableId,
          likesCount: comment.likesCount + 1,
          repliesCount: comment.repliesCount,
          isLikedByMe: true,
          createdAt: comment.createdAt,
          updatedAt: comment.updatedAt,
        );
      }

      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Unlike a comment
  Future<void> unlikeComment(int commentId) async {
    try {
      await _repository.unlikeComment(commentId);

      // Update the comment
      final index = _comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        final comment = _comments[index];
        _comments[index] = Comment(
          id: comment.id,
          userId: comment.userId,
          userName: comment.userName,
          userImage: comment.userImage,
          content: comment.content,
          commentableType: comment.commentableType,
          commentableId: comment.commentableId,
          likesCount: (comment.likesCount - 1).clamp(0, double.infinity).toInt(),
          repliesCount: comment.repliesCount,
          isLikedByMe: false,
          createdAt: comment.createdAt,
          updatedAt: comment.updatedAt,
        );
      }

      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Reset state
  void resetComments() {
    _comments = [];
    _commentsPage = 1;
    _totalComments = 0;
    _hasMore = true;
    _errorMessage = null;
    notifyListeners();
  }
}
