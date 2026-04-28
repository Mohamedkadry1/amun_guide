import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Exception class for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Response wrapper class
class ApiResponse<T> {
  final T? data;
  final bool success;
  final String? message;
  final int statusCode;

  ApiResponse({
    this.data,
    required this.success,
    this.message,
    required this.statusCode,
  });

  factory ApiResponse.success({required T data, required int statusCode}) {
    return ApiResponse(
      data: data,
      success: true,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({
    required String message,
    int statusCode = 0,
  }) {
    return ApiResponse(
      data: null,
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }
}

/// HTTP Client with token management and interceptors
class ApiService {
  static const String _baseUrl = 'https://web-production-67454.up.railway.app/api/v1';
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const int _timeout = 30;

  final _secureStorage = const FlutterSecureStorage();
  String? _token;

  ApiService() {
    _loadTokens();
  }

  /// Load stored tokens from secure storage
  Future<void> _loadTokens() async {
    try {
      _token = await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      print('Error loading tokens: $e');
    }
  }

  /// Save tokens to secure storage
  Future<void> _saveTokens(String token, String? refreshToken) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
      _token = token;
    } catch (e) {
      print('Error saving tokens: $e');
    }
  }

  /// Public method to save tokens
  Future<void> saveTokens(String token) async {
    await _saveTokens(token, null);
  }

  /// Clear stored tokens
  Future<void> clearTokens() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      _token = null;
    } catch (e) {
      print('Error clearing tokens: $e');
    }
  }

  /// Get current token
  String? getToken() => _token;

  /// Set token manually (for testing or external auth)
  void setToken(String token) {
    _token = token;
  }

  /// Build headers with authorization
  Map<String, String> _buildHeaders({bool includeAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  /// Perform GET request
  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      
      final response = await http.get(
        url,
        headers: _buildHeaders(includeAuth: includeAuth),
      ).timeout(
        const Duration(seconds: _timeout),
        onTimeout: () => throw TimeoutException('Request timeout'),
      );

      return _handleResponse<T>(response, fromJson);
    } on SocketException catch (e) {
      throw ApiException(
        message: 'Network error: ${e.message}',
        originalError: e,
      );
    } on TimeoutException catch (e) {
      throw ApiException(
        message: 'Request timeout: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      throw ApiException(
        message: 'GET request failed: $e',
        originalError: e,
      );
    }
  }

  /// Perform POST request
  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      
      final response = await http.post(
        url,
        headers: _buildHeaders(includeAuth: includeAuth),
        body: jsonEncode(data),
      ).timeout(
        const Duration(seconds: _timeout),
        onTimeout: () => throw TimeoutException('Request timeout'),
      );

      return _handleResponse<T>(response, fromJson);
    } on SocketException catch (e) {
      throw ApiException(
        message: 'Network error: ${e.message}',
        originalError: e,
      );
    } on TimeoutException catch (e) {
      throw ApiException(
        message: 'Request timeout: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      throw ApiException(
        message: 'POST request failed: $e',
        originalError: e,
      );
    }
  }

  /// Perform PUT request
  Future<ApiResponse<T>> put<T>({
    required String endpoint,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      
      final response = await http.put(
        url,
        headers: _buildHeaders(includeAuth: includeAuth),
        body: jsonEncode(data),
      ).timeout(
        const Duration(seconds: _timeout),
        onTimeout: () => throw TimeoutException('Request timeout'),
      );

      return _handleResponse<T>(response, fromJson);
    } on SocketException catch (e) {
      throw ApiException(
        message: 'Network error: ${e.message}',
        originalError: e,
      );
    } on TimeoutException catch (e) {
      throw ApiException(
        message: 'Request timeout: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      throw ApiException(
        message: 'PUT request failed: $e',
        originalError: e,
      );
    }
  }

  /// Perform DELETE request
  Future<ApiResponse<T>> delete<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    bool includeAuth = true,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      
      final response = await http.delete(
        url,
        headers: _buildHeaders(includeAuth: includeAuth),
      ).timeout(
        const Duration(seconds: _timeout),
        onTimeout: () => throw TimeoutException('Request timeout'),
      );

      return _handleResponse<T>(response, fromJson);
    } on SocketException catch (e) {
      throw ApiException(
        message: 'Network error: ${e.message}',
        originalError: e,
      );
    } on TimeoutException catch (e) {
      throw ApiException(
        message: 'Request timeout: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      throw ApiException(
        message: 'DELETE request failed: $e',
        originalError: e,
      );
    }
  }

  /// Handle HTTP response
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final statusCode = response.statusCode;
    
    try {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

      switch (statusCode) {
        case 200:
        case 201:
          // Success - extract data
          final data = jsonData['data'] ?? jsonData;
          if (data is Map<String, dynamic>) {
            return ApiResponse.success(
              data: fromJson(data),
              statusCode: statusCode,
            );
          }
          throw ApiException(
            message: 'Invalid response format',
            statusCode: statusCode,
          );

        case 400:
          final message = jsonData['message'] ?? 'Bad request';
          throw ApiException(
            message: message,
            statusCode: statusCode,
          );

        case 401:
          // Unauthorized - token expired or invalid
          clearTokens();
          throw ApiException(
            message: 'Unauthorized - please login again',
            statusCode: statusCode,
          );

        case 403:
          throw ApiException(
            message: 'Forbidden - access denied',
            statusCode: statusCode,
          );

        case 404:
          throw ApiException(
            message: 'Not found',
            statusCode: statusCode,
          );

        case 500:
        case 502:
        case 503:
          throw ApiException(
            message: 'Server error - please try again later',
            statusCode: statusCode,
          );

        default:
          throw ApiException(
            message: 'Unknown error occurred',
            statusCode: statusCode,
          );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to parse response: $e',
        statusCode: statusCode,
        originalError: e,
      );
    }
  }

  /// Upload file (multipart)
  Future<ApiResponse<T>> uploadFile<T>({
    required String endpoint,
    required String filePath,
    required String fieldName,
    Map<String, String>? additionalFields,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers.addAll(_buildHeaders());

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, filePath),
      );

      // Add additional fields
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: _timeout),
        onTimeout: () => throw TimeoutException('Request timeout'),
      );

      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      throw ApiException(
        message: 'File upload failed: $e',
        originalError: e,
      );
    }
  }
}

// Socket exception import fix
class SocketException implements Exception {
  final String message;
  SocketException(this.message);
}
