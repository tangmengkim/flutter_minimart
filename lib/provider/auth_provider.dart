import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ministore/dio/baseDio.dart';
import 'package:ministore/dio/models/auth_model.dart';
import 'package:ministore/dio/services/auth_service.dart';
import 'package:ministore/util/data.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _awaitingOtp = false;
  String? _email;

  // Forgot password specific variables
  String? _resetEmail;
  String? _resetToken;
  bool _isResetMode = false;

  // Cache authentication state for synchronous access
  bool _isAuthenticated = false;
  User? _currentUser;
  String? _authToken;

  // Getters
  String? get email => _email;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get awaitingOtp => _awaitingOtp;
  bool get isResetMode => _isResetMode;
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  String? get authToken => _authToken;

  AuthProvider() {
    _initializeAuthState();
  }

  // Initialize authentication state from storage
  Future<void> _initializeAuthState() async {
    try {
      final isAuth = await Data().get<bool>(DataKeys.isUserAuth) ?? false;
      final user =
          await Data().get<User>(DataKeys.userInfo, fromJson: User.fromJson);
      final authData = await Data()
          .get<LoginData>(DataKeys.userAuth, fromJson: LoginData.fromJson);

      _isAuthenticated = isAuth;
      _currentUser = user;
      _authToken = authData?.token;

      notifyListeners();
    } catch (e) {
      print('Error initializing auth state: $e');
      _isAuthenticated = false;
      _currentUser = null;
      _authToken = null;
    }
  }

  // Update cached auth state
  Future<void> _updateAuthState({
    bool? isAuthenticated,
    User? user,
    String? token,
  }) async {
    if (isAuthenticated != null) _isAuthenticated = isAuthenticated;
    if (user != null) _currentUser = user;
    if (token != null) _authToken = token;
    notifyListeners();
  }

  Future<void> login(String email, String password, {Function? onError}) async {
    _isLoading = true;
    _error = null;
    _awaitingOtp = false;
    _isResetMode = false;
    notifyListeners();

    try {
      final LoginResp response = await AuthService().login(
        LoginReq(email: email, password: password),
      );
      print("Login response: ${response}");

      if (response.success) {
        print("Login successful");  

        // Save to storage
        await Data().put<LoginData>(DataKeys.userAuth, response.data);
        await Data().put<User>(DataKeys.userInfo, response.data.user);
        await Data().put<bool>(DataKeys.isUserAuth, true);

        // Update cached state
        await _updateAuthState(
          isAuthenticated: true,
          user: response.data.user,
          token: response.data.token,
        );

        _awaitingOtp = false;
        _email = null;
        _isLoading = false;
        notifyListeners();
        return;
      }
    } catch (e) {
      print(e);
      _error = "Login failed";
      throw Exception("Login failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Forgot Password - Send OTP
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _error = null;
    _isResetMode = true;
    notifyListeners();

    try {
      final response = await BaseDio().post(
        '/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode == 200 && response.data['success']) {
        _resetEmail = email;
        _resetToken = response.data['data']['token'];
        _awaitingOtp = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.data['message'] ?? 'Failed to send OTP';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _error = e.response?.data['message'] ?? 'Failed to send OTP';
      } else {
        _error = 'Network error. Please try again.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Verify OTP for Password Reset
  Future<bool> verifyResetOtp(String otp) async {
    if (_resetEmail == null || _resetToken == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await BaseDio().post(
        '/verify-otp',
        data: {
          'email': _resetEmail,
          'otp': otp,
          'token': _resetToken,
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.data['message'] ?? 'Invalid or expired OTP';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _error = e.response?.data['message'] ?? 'Invalid or expired OTP';
      } else {
        _error = 'Network error. Please try again.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset Password
  Future<bool> resetPassword(
      String otp, String newPassword, String confirmPassword) async {
    if (_resetEmail == null || _resetToken == null) {
      _error = 'Invalid reset session. Please start the process again.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await BaseDio().post(
        '/reset-password',
        data: {
          'email': _resetEmail,
          'otp': otp,
          'password': newPassword,
          'password_confirmation': confirmPassword,
          'token': _resetToken, // THIS WAS MISSING - ADD THE TOKEN!
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        // Reset state after successful password reset
        _clearForgotPasswordState();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.data['message'] ?? 'Failed to reset password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _error = e.response?.data['message'] ?? 'Failed to reset password';
      } else {
        _error = 'Network error. Please try again.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear forgot password state
  void clearForgotPasswordState() {
    _clearForgotPasswordState();
    notifyListeners();
  }

  void _clearForgotPasswordState() {
    _awaitingOtp = false;
    _resetEmail = null;
    _resetToken = null;
    _isResetMode = false;
    _error = null;
  }

  Future<void> logout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Call logout API if you have one
      try {
        // Check what parameter AuthService().logout() expects
        // Option 1: If it expects a token
        if (_authToken != null) {
          await AuthService().logout(_authToken!);
        }

        // Option 2: If it expects a request object, uncomment this:
        // await AuthService().logout(LogoutReq());

        // Option 3: If you don't need the API call, comment out the entire try block:
        // await AuthService().logout();
      } catch (e) {
        print('Logout API call failed: $e');
        // Continue with local logout even if API fails
      }

      // Clear local data
      await Data().put<bool>(DataKeys.isUserAuth, false);
      await Data().removeAll();

      // Clear cached state
      await _updateAuthState(
        isAuthenticated: false,
        user: null,
        token: null,
      );

      // Clear all state
      _awaitingOtp = false;
      _email = null;
      _clearForgotPasswordState();
    } catch (e) {
      _error = "Logout failed";
      print('Logout error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // This method can be used for both login OTP and reset OTP
  Future<bool> verifyOtp(String otp) async {
    if (_isResetMode) {
      return await verifyResetOtp(otp);
    }

    // Original login OTP verification logic
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement login OTP verification API call
      // Example:
      // final response = await AuthService().verifyLoginOtp(
      //   VerifyOtpReq(email: _email!, otp: otp),
      // );
      //
      // if (response.success) {
      //   // Save login data
      //   await Data().put<LoginData>(DataKeys.userAuth, response.data);
      //   await Data().put<User>(DataKeys.userInfo, response.data.user);
      //   await Data().put<bool>(DataKeys.isUserAuth, true);
      //
      //   // Update cached state
      //   await _updateAuthState(
      //     isAuthenticated: true,
      //     user: response.data.user,
      //     token: response.data.token,
      //   );
      //
      //   _awaitingOtp = false;
      //   _email = null;
      //   _isLoading = false;
      //   notifyListeners();
      //   return true;
      // }

      _error = "OTP verification not implemented yet";
    } catch (e) {
      _error = "OTP verification failed";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Helper methods for async data access (if needed)
  Future<bool> getIsAuthenticatedAsync() async {
    try {
      return await Data().get<bool>(DataKeys.isUserAuth) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<User?> getCurrentUserAsync() async {
    try {
      return await Data().get<User>(DataKeys.userInfo, fromJson: User.fromJson);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getAuthTokenAsync() async {
    try {
      final authData = await Data()
          .get<LoginData>(DataKeys.userAuth, fromJson: LoginData.fromJson);
      return authData?.token;
    } catch (e) {
      return null;
    }
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await BaseDio().post(
        '/change-password',
        data: {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.data['message'] ?? 'Failed to change password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;

        // Handle validation errors
        if (e.response?.statusCode == 422 && errorData != null) {
          if (errorData['errors'] != null) {
            // Extract first validation error
            final errors = errorData['errors'] as Map<String, dynamic>;
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              _error = firstError.first.toString();
            } else {
              _error = 'Validation error occurred';
            }
          } else {
            _error = errorData['message'] ?? 'Validation error occurred';
          }
        } else {
          _error = errorData?['message'] ?? 'Failed to change password';
        }
      } else {
        _error = 'Network error. Please try again.';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Refresh auth state from storage (useful after app restart)
  Future<void> refreshAuthState() async {
    await _initializeAuthState();
  }

  // Check if token is valid/not expired (implement based on your token structure)
  bool get isTokenValid {
    if (_authToken == null) return false;

    // TODO: Implement token validation logic
    // For example, check token expiration:
    // try {
    //   final parts = _authToken!.split('.');
    //   if (parts.length != 3) return false;
    //
    //   final payload = json.decode(
    //     utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    //   );
    //
    //   final exp = payload['exp'] as int?;
    //   if (exp == null) return true; // No expiration
    //
    //   final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    //   return exp > now;
    // } catch (e) {
    //   return false;
    // }

    return true; // Placeholder
  }

  // Auto-refresh auth state if needed
  Future<void> ensureValidAuth() async {
    if (!_isAuthenticated || !isTokenValid) {
      await logout();
    }
  }
}
