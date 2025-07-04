import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ministore/dio/models/auth_model.dart';
import 'package:ministore/util/data.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class BaseDio {
  static String baseUrl = 'your base url';
  LoginData? _loginData;
  final Dio _dio;

  static BaseDio? _instance;

  BaseDio._()
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // print('Request: ${options.method} ${options.path} ${options.data}');
          log('Request: ${options.method} ${options.path} ${options.data}',
              name: 'BaseDio');
          handler.next(options);
        },
        onResponse: (response, handler) {
          log('Response: ${response.statusCode} ${response.statusMessage} ${response.data}',
              name: 'BaseDio');
          handler.next(response);
        },
        onError: (e, handler) {
          handler.next(e);
        },
      ),
    );

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

  static BaseDio getInstance() {
    _instance ??= BaseDio._();
    return _instance!;
  }

  Dio getDio() {
    return _dio;
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
    required TRes Function(dynamic) fromJson,
  }) async {
    try {
      final response = await _dio.get(endpoint);
      // return fromJson(response.data['data']);
      print("api: ${response.data}");
      var apiResponse = fromJson(response.data);
      return apiResponse;
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

  Future<void> setLoginData() async {
    _loginData = await Data()
        .get<LoginData>(DataKeys.userAuth, fromJson: LoginData.fromJson);
    if (_loginData != null && _loginData!.token != null) {
      _dio.options.headers['Authorization'] = 'Bearer ${_loginData!.token}';
    }
    print("=========> ${_loginData?.token}");
  }
}
