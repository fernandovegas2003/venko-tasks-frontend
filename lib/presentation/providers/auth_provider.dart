import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venko_tasks_flutter_frontend/constants/app_constants.dart';
import 'package:venko_tasks_flutter_frontend/core/networkt/api_client.dart';
import 'package:venko_tasks_flutter_frontend/models/auth_model.dart';


final authProvider = StateNotifierProvider<AuthController, AsyncValue<AuthResponse?>>(
  (ref) => AuthController(ref),
);

class AuthController extends StateNotifier<AsyncValue<AuthResponse?>> {
  final Ref ref;
  
  AuthController(this.ref) : super(const AsyncLoading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.tokenKey);
      final username = prefs.getString(AppConstants.usernameKey);
      final email = prefs.getString(AppConstants.emailKey);
      final userId = prefs.getInt(AppConstants.userIdKey);
      
      if (token != null && username != null && email != null && userId != null) {
        state = AsyncData(AuthResponse(
          token: token,
          type: 'Bearer',
          userId: userId,
          username: username,
          email: email,
          createdAt: DateTime.now(),
        ));
      } else {
        state = const AsyncData(null);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.login(email, password);
      
      final authResponse = AuthResponse.fromJson(response);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, authResponse.token);
      await prefs.setString(AppConstants.usernameKey, authResponse.username);
      await prefs.setString(AppConstants.emailKey, authResponse.email);
      await prefs.setInt(AppConstants.userIdKey, authResponse.userId);
      
      state = AsyncData(authResponse);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> register(String username, String email, String password) async {
    state = const AsyncLoading();
    
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.register(username, email, password);
      
      final authResponse = AuthResponse.fromJson(response);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.tokenKey, authResponse.token);
      await prefs.setString(AppConstants.usernameKey, authResponse.username);
      await prefs.setString(AppConstants.emailKey, authResponse.email);
      await prefs.setInt(AppConstants.userIdKey, authResponse.userId);
      
      state = AsyncData(authResponse);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> clearError() {
    state = const AsyncData(null);
    return Future.value();
  }
}