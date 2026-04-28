import 'package:amin_gide/core/services/api_service.dart';
import 'package:amin_gide/features/auth/models/auth_models.dart';

/// Authentication Repository
class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  /// Login with email and password
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      
      final response = await _apiService.post<AuthResponse>(
        endpoint: '/auth/login',
        data: request.toJson(),
        fromJson: AuthResponse.fromJson,
        includeAuth: false,
      );

      if (response.success && response.data != null) {
        // Save token
        await _apiService.saveTokens(response.data!.accessToken);
        return response.data!;
      }

      throw ApiException(
        message: response.message ?? 'Login failed',
        statusCode: response.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Register new user
  Future<AuthResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String userType,
  }) async {
    try {
      final request = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        userType: userType,
      );

      final response = await _apiService.post<AuthResponse>(
        endpoint: '/auth/register',
        data: request.toJson(),
        fromJson: AuthResponse.fromJson,
        includeAuth: false,
      );

      if (response.success && response.data != null) {
        // Save token
        await _apiService.saveTokens(response.data!.accessToken);
        return response.data!;
      }

      throw ApiException(
        message: response.message ?? 'Registration failed',
        statusCode: response.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Forgot password - send reset email
  Future<String> forgotPassword({required String email}) async {
    try {
      final request = ForgotPasswordRequest(email: email);

      final response = await _apiService.post<Map<String, dynamic>>(
        endpoint: '/auth/forgot-password',
        data: request.toJson(),
        fromJson: (json) => json,
        includeAuth: false,
      );

      if (response.success) {
        return response.data?['message'] ?? 'Reset email sent successfully';
      }

      throw ApiException(
        message: response.message ?? 'Failed to send reset email',
        statusCode: response.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password with token
  Future<String> resetPassword({
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final request = ResetPasswordRequest(
        token: token,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      final response = await _apiService.post<ResetPasswordResponse>(
        endpoint: '/auth/reset-password',
        data: request.toJson(),
        fromJson: ResetPasswordResponse.fromJson,
        includeAuth: false,
      );

      if (response.success && response.data != null) {
        return response.data!.message;
      }

      throw ApiException(
        message: response.message ?? 'Password reset failed',
        statusCode: response.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user profile
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiService.get<User>(
        endpoint: '/auth/user',
        fromJson: User.fromJson,
        includeAuth: true,
      );

      if (response.success && response.data != null) {
        return response.data!;
      }

      throw ApiException(
        message: response.message ?? 'Failed to fetch user profile',
        statusCode: response.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Logout
  Future<String> logout() async {
    try {
      final response = await _apiService.post<LogoutResponse>(
        endpoint: '/auth/logout',
        data: {},
        fromJson: LogoutResponse.fromJson,
        includeAuth: true,
      );

      // Clear tokens regardless of response
      await _apiService.clearTokens();

      if (response.success && response.data != null) {
        return response.data!.message;
      }

      return 'Logged out successfully';
    } catch (e) {
      // Clear tokens even if request fails
      await _apiService.clearTokens();
      rethrow;
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _apiService.getToken() != null;
  }

  /// Get stored token
  String? getToken() {
    return _apiService.getToken();
  }
}
