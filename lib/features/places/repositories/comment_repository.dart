import '../models/comment_models.dart';
import '../../../core/services/api_service.dart';

class CommentRepository {
  final ApiService _apiService;

  CommentRepository(this._apiService);

  /// Get comments for a specific resource (place, tour, plan, etc.)
  Future<CommentsResponse> getComments({
    required String type, // 'places', 'tours', 'plans'
    required int resourceId,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final query = '?page=$page&per_page=$perPage';
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/comments/$type/$resourceId$query',
        fromJson: (json) => json,
        includeAuth: false,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to fetch comments');
      }

      return CommentsResponse.fromJson(response.data ?? {});
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  /// Create a new comment
  Future<Comment> createComment({
    required String content,
    required String commentableType, // 'places', 'tours', 'plans'
    required int commentableId,
  }) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/comments',
        data: {
          'content': content,
          'commentable_type': commentableType,
          'commentable_id': commentableId,
        },
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to create comment');
      }

      final commentData = response.data?['data'] ?? response.data;
      return Comment.fromJson(commentData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error creating comment: $e');
    }
  }

  /// Update an existing comment
  Future<Comment> updateComment({
    required int commentId,
    required String content,
  }) async {
    try {
      final response = await _apiService.put<Map<String, dynamic>>(
        endpoint: '/comments/$commentId',
        data: {'content': content},
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to update comment');
      }

      final commentData = response.data?['data'] ?? response.data;
      return Comment.fromJson(commentData as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error updating comment: $e');
    }
  }

  /// Delete a comment
  Future<void> deleteComment(int commentId) async {
    try {
      final response = await _apiService.delete<Map<String, dynamic>>(
        endpoint: '/comments/$commentId',
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to delete comment');
      }
    } catch (e) {
      throw Exception('Error deleting comment: $e');
    }
  }

  /// Get all comments by current user
  Future<List<Comment>> getUserComments({int page = 1, int perPage = 20}) async {
    try {
      final query = '?page=$page&per_page=$perPage';
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/user/comments$query',
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to fetch user comments');
      }

      final data = response.data ?? {};
      final commentsList = (data['data'] as List?)
          ?.map((c) => Comment.fromJson(c as Map<String, dynamic>))
          .toList() ??
          [];
      return commentsList;
    } catch (e) {
      throw Exception('Error fetching user comments: $e');
    }
  }

  /// Get comment count for a resource
  Future<int> getCommentCount({
    required String type,
    required int resourceId,
  }) async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        endpoint: '/$type/$resourceId/comments/count',
        fromJson: (json) => json,
        includeAuth: false,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to fetch comment count');
      }

      return response.data?['count'] as int? ?? 0;
    } catch (e) {
      throw Exception('Error fetching comment count: $e');
    }
  }

  /// Like a comment
  Future<void> likeComment(int commentId) async {
    try {
      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/comments/$commentId/like',
        data: {},
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to like comment');
      }
    } catch (e) {
      throw Exception('Error liking comment: $e');
    }
  }

  /// Unlike a comment
  Future<void> unlikeComment(int commentId) async {
    try {
      final response = await _apiService.delete<Map<String, dynamic>>(
        endpoint: '/comments/$commentId/like',
        fromJson: (json) => json,
        includeAuth: true,
      );

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to unlike comment');
      }
    } catch (e) {
      throw Exception('Error unliking comment: $e');
    }
  }
}
