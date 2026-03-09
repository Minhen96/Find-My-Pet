import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/dio_client.dart';
import '../models/auth_response.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<AuthResponse> login(String email, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'fullName': fullName,
        if (phoneNumber != null && phoneNumber.isNotEmpty)
          'phoneNumber': phoneNumber,
      },
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(dioClientProvider);
  return AuthRepository(dio);
}
