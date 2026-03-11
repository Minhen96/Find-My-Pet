import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/secure_storage_service.dart';
import 'api_constants.dart';

part 'dio_client.g.dart';

@riverpod
Dio dioClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ),
  );

  // Add Auth Interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Read token from storage on every request
        final secureStorage = ref.read(secureStorageProvider);
        final token = await secureStorage.getAccessToken();
        
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // Handle 401 Unauthorized globally (e.g. expired token)
        if (e.response?.statusCode == 401) {
          // In a full implementation, trigger token refresh here. 
          // For now, clear tokens and force logout on 401
          final secureStorage = ref.read(secureStorageProvider);
          await secureStorage.clearTokens();
          // We don't have direct access to authProvider here to state = null,
          // but next time the app reloads or auth state checks, it will require login.
        }
        return handler.next(e);
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ),
  );

  return dio;
}
