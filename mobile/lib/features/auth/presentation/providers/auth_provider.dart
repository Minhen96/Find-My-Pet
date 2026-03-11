import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/error_utils.dart';
import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  FutureOr<User?> build() async {
    final secureStorage = ref.read(secureStorageProvider);
    final token = await secureStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      try {
        final repository = ref.read(authRepositoryProvider);
        return await repository.getProfile();
      } catch (e) {
        // If profile fetch fails (e.g., token expired), clear tokens
        await secureStorage.clearTokens();
        return null;
      }
    }

    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(authRepositoryProvider);
        final response = await repository.login(email, password);

        final secureStorage = ref.read(secureStorageProvider);
        await secureStorage.saveTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        );

        return response.user;
      } catch (e, stackTrace) {
        debugPrint('AUTH PROVIDER CRASH: $e');
        debugPrint(stackTrace.toString());
        if (e is DioException) {
          if (e.response?.data != null) {
            throw Exception(ErrorUtils.extractErrorMessage(e.response!.data));
          }
          throw Exception(e.message ?? 'Login failed');
        }
        // If it's a TypeError or FormatException (from JSON parsing)
        throw Exception(e.toString());
      }
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    String? phoneNumber,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        final repository = ref.read(authRepositoryProvider);
        final response = await repository.register(
          email: email,
          password: password,
          displayName: displayName,
          phoneNumber: phoneNumber,
        );

        final secureStorage = ref.read(secureStorageProvider);
        await secureStorage.saveTokens(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        );

        return response.user;
      } catch (e) {
        if (e is DioException) {
          if (e.response?.data != null) {
            throw Exception(ErrorUtils.extractErrorMessage(e.response!.data));
          }
          throw Exception(e.message ?? 'Registration failed');
        }
        throw Exception(e.toString());
      }
    });
  }

  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.updateProfile(
        displayName: displayName,
        bio: bio,
        avatarUrl: avatarUrl,
      );
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.clearTokens();
    state = const AsyncData(null);
  }
}
