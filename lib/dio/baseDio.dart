import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ministore/dio/models/auth_model.dart';
import 'package:ministore/util/data.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class BaseDio {
  static String baseUrl =
      'https://mini-mart-api-main-qocdxt.laravel.cloud/api/v1';
  LoginData? _loginData;
  final Dio _dio;

  static BaseDio? _instance;

  BaseDio._()
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _setupInterceptors();
  }

  static BaseDio getInstance() {
    _instance ??= BaseDio._();
    return _instance!;
  }

  // Factory constructor for easier access
  factory BaseDio() => getInstance();

  Dio getDio() => _dio;

  void _setupInterceptors() {
    // Request/Response Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _setAuthHeaders(options);
          log('🚀 Request: ${options.method} ${options.path}', name: 'BaseDio');
          log('📦 Data: ${options.data}', name: 'BaseDio');
          handler.next(options);
        },
        onResponse: (response, handler) {
          log('✅ Response: ${response.statusCode} ${response.statusMessage}',
              name: 'BaseDio');
          handler.next(response);
        },
        onError: (error, handler) async {
          log('❌ Error: ${error.response?.statusCode} ${error.message}',
              name: 'BaseDio');

          // Handle token expiration
          if (error.response?.statusCode == 401) {
            await _handleUnauthorized();
          }

          handler.next(error);
        },
      ),
    );

    // Retry Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (_shouldRetry(error)) {
            try {
              final response = await _retry(error.requestOptions);
              handler.resolve(response);
              return;
            } catch (e) {
              log('🔄 Retry failed: $e', name: 'BaseDio');
            }
          }
          handler.next(error);
        },
      ),
    );

    // Pretty Logger (only in debug mode)
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  Future<void> _setAuthHeaders(RequestOptions options) async {
    try {
      _loginData = await Data()
          .get<LoginData>(DataKeys.userAuth, fromJson: LoginData.fromJson);

      if (_loginData?.token != null) {
        options.headers['Authorization'] = 'Bearer ${_loginData!.token}';
        log('🔐 Auth token set', name: 'BaseDio');
      }
    } catch (e) {
      log('⚠️ Failed to set auth headers: $e', name: 'BaseDio');
    }
  }

  Future<void> _handleUnauthorized() async {
    log('🚨 Unauthorized - clearing auth data', name: 'BaseDio');
    try {
      await Data().remove(DataKeys.userAuth);
      await Data().put<bool>(DataKeys.isUserAuth, false);
      // You might want to trigger a logout event here
    } catch (e) {
      log('⚠️ Failed to clear auth data: $e', name: 'BaseDio');
    }
  }

  bool _shouldRetry(DioException error) {
    // Retry on network errors, timeouts, and 5xx server errors
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    // Wait a bit before retrying
    await Future.delayed(const Duration(seconds: 1));

    // Create a new Dio instance for retry to avoid interceptor loops
    final retryDio = Dio(_dio.options);
    await _setAuthHeaders(requestOptions);

    return retryDio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }

  // Enhanced HTTP methods with better error handling

  /// Generic POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Generic GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Generic PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Generic DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Generic PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Type-safe request methods (keeping your original pattern)

  Future<TRes> postRequest<TReq, TRes>({
    required String endpoint,
    required TReq req,
    required TRes Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(TReq) toJson,
  }) async {
    try {
      final response = await post(endpoint, data: toJson(req));
      return fromJson(response.data);
    } catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<TRes> getRequest<TRes>({
    required String endpoint,
    required TRes Function(dynamic) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await get(endpoint, queryParameters: queryParameters);
      log("📨 API Response: ${response.data}", name: 'BaseDio');
      return fromJson(response.data);
    } catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<TRes> putRequest<TReq, TRes>({
    required String endpoint,
    required TReq req,
    required TRes Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(TReq) toJson,
  }) async {
    try {
      final response = await put(endpoint, data: toJson(req));
      return fromJson(response.data);
    } catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<TRes> deleteRequest<TRes>({
    required String endpoint,
    required TRes Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await delete(endpoint);
      return fromJson(response.data);
    } catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // File upload method
  Future<Response> uploadFile(
    String path,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData();

      // Add file
      formData.files.add(MapEntry(
        fieldName,
        await MultipartFile.fromFile(file.path),
      ));

      // Add additional data
      if (additionalData != null) {
        additionalData.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      return await post(
        path,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // Download file method
  Future<Response> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: 408,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection. Please check your network.',
          statusCode: 0,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message =
            e.response?.data?['message'] ?? _getStatusMessage(statusCode);
        return ApiException(
          message: message,
          statusCode: statusCode,
          data: e.response?.data,
        );
      default:
        return ApiException(
          message: e.message ?? 'An unexpected error occurred',
          statusCode: 0,
        );
    }
  }

  String _getStatusMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden. You don\'t have permission.';
      case 404:
        return 'Resource not found.';
      case 422:
        return 'Validation error. Please check your input.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // Utility methods
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
    _loginData = null;
  }

  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }
}

// Custom exception class for better error handling
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory ApiException.fromDioException(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode ?? 0;
      final message = error.response?.data?['message'] ??
          error.message ??
          'An unexpected error occurred';

      return ApiException(
        message: message,
        statusCode: statusCode,
        data: error.response?.data,
      );
    }

    return ApiException(
      message: error.toString(),
      statusCode: 0,
    );
  }

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';

  bool get isNetworkError => statusCode == 0;
  bool get isUnauthorized => statusCode == 401;
  bool get isValidationError => statusCode == 422;
  bool get isServerError => statusCode >= 500;
}
