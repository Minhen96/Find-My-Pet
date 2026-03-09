import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  FutureOr<User?> build() async {
    final secureStorage = ref.read(secureStorageProvider);
    final token = await secureStorage.getAccessToken();
    
    // If we have a token, we could optionally hit a `/auth/me` endpoint to validate it
    // and fetch the latest user object. For MVP, we'll try to decode it or just 
    // leave it as null user but with a valid token so guards let us through.
    // Assuming backend returns user info with login. Let's just return null if no token, 
    // or try to fetch user if token exists. Since we don't have `/auth/me` yet,
    // we'll just check if token exists. A better approach is fetching user profile.
    
    if (token != null && token.isNotEmpty) {
      // NOTE: We ideally need a fetchProfile() in the repository to populate this User object on app restart.
      // For now, if there's a token, the user is conceptually logged in. 
      // We will leave the user object as null but the interceptor will use the token.
      // A more complete implementation would decode the JWT or fetch the profile here.
    }
    
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.login(email, password);
      
      final secureStorage = ref.read(secureStorageProvider);
      await secureStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      
      return response.user;
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.register(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
      
      final secureStorage = ref.read(secureStorageProvider);
      await secureStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      
      return response.user;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final secureStorage = ref.read(secureStorageProvider);
    await secureStorage.clearTokens();
    state = const AsyncData(null);
  }
}
