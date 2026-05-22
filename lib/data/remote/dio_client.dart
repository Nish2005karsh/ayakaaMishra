import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Accept-Language': 'en-US,en;q=0.9',
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 13; SM-S908U1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
          'X-Requested-With': 'XMLHttpRequest',
        },
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
