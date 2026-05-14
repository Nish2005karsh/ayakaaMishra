import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Accept': 'application/json'},
        responseType: ResponseType.json,
      ),
    );
    if (kDebugMode) {
      _instance!.interceptors.removeWhere((i) => i is LogInterceptor);
      _instance!.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
    return _instance!;
  }
}
