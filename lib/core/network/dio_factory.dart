import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_endpoints.dart';

 
abstract final class DioFactory {
  const DioFactory._();

  static Dio create({
    String baseUrl = ApiEndpoints.baseUrl,
    bool enableLogging = kDebugMode,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiEndpoints.connectTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        sendTimeout: ApiEndpoints.sendTimeout,
        responseType: ResponseType.json,
        headers: const <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
 
        validateStatus: (status) => status != null && status >= 200 && status < 300,
      ),
    );

    if (enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: false,
          logPrint: (Object object) =>
              developer.log('$object', name: 'dio'),
        ),
      );
    }

    return dio;
  }
}
