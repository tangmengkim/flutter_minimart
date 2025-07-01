import 'package:dio/dio.dart';

const String baseUrl = 'https://your-api-url.com/api';

class DioService {
  final Dio _dio;

  DioService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log request
          print('Request: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response
          print('Response: ${response.statusCode}');
          handler.next(response);
        },
        onError: (e, handler) {
          // Log error
          print('Error: ${e.message}');
          handler.next(e);
        },
      ),
    );
  }

  Future<TRes> postRequest<TReq, TRes>({
    required String endpoint,
    required TReq req,
    required TRes Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(TReq) toJson,
  }) async {
    try {
      final response = await _dio.post(endpoint, data: toJson(req));
      return fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<TRes> getRequest<TRes>({
    required String endpoint,
    required TRes Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(endpoint);
      return fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<TRes> putRequest<TReq, TRes>({
    required String endpoint,
    required TReq req,
    required TRes Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(TReq) toJson,
  }) async {
    try {
      final response = await _dio.put(endpoint, data: toJson(req));
      return fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<TRes> deleteRequest<TRes>({
    required String endpoint,
    required TRes Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.delete(endpoint);
      return fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
