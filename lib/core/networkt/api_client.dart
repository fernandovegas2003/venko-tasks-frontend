import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venko_tasks_flutter_frontend/exceptions/app_exceptions.dart';

import '../../constants/app_constants.dart' show AppConstants;


final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  static const String _baseUrl = AppConstants.baseUrl;
  
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  Future<dynamic> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      String errorMessage = 'Error ${response.statusCode}';
      
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorMessage;
      } catch (_) {}
      
      switch (response.statusCode) {
        case 400:
          throw ValidationException(errorMessage);
        case 401:
          throw AuthenticationException(errorMessage);
        case 404:
          throw NotFoundException(errorMessage);
        case 500:
          throw ServerException(errorMessage);
        default:
          throw AppException(errorMessage);
      }
    }
  }
  
  // Auth
  Future<dynamic> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl${AppConstants.login}'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'username': email.split('@')[0],
        'email': email,
        'password': password,
      }),
    );
    
    return await _handleResponse(response);
  }
  
  Future<dynamic> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl${AppConstants.register}'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    
    return await _handleResponse(response);
  }
  
  // Tasks
  Future<List<dynamic>> getTasks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl${AppConstants.tasks}'),
      headers: await _getHeaders(),
    );
    
    return await _handleResponse(response) ?? [];
  }
  
  Future<dynamic> getTaskById(int id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl${AppConstants.tasks}/$id'),
      headers: await _getHeaders(),
    );
    
    return await _handleResponse(response);
  }
  
  Future<dynamic> createTask(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl${AppConstants.tasks}'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    
    return await _handleResponse(response);
  }
  
  Future<dynamic> updateTask(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl${AppConstants.tasks}/$id'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    
    return await _handleResponse(response);
  }
  
  Future<void> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl${AppConstants.tasks}/$id'),
      headers: await _getHeaders(),
    );
    
    await _handleResponse(response);
  }
  
  Future<dynamic> startTask(int id) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl${AppConstants.tasks}/$id/start'),
      headers: await _getHeaders(),
    );
    
    return await _handleResponse(response);
  }
  
  Future<dynamic> completeTask(int id) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl${AppConstants.tasks}/$id/complete'),
      headers: await _getHeaders(),
    );
    
    return await _handleResponse(response);
  }
  
  Future<dynamic> cancelTask(int id) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl${AppConstants.tasks}/$id/cancel'),
      headers: await _getHeaders(),
    );
    
    return await _handleResponse(response);
  }
  
  Future<dynamic> reopenTask(int id) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl${AppConstants.tasks}/$id/reopen'),
      headers: await _getHeaders(),
    );
    
    return await _handleResponse(response);
  }
  
  Future<List<dynamic>> getTasksByStatus(String status) async {
    final response = await http.get(
      Uri.parse('$_baseUrl${AppConstants.tasks}/status/$status'),
      headers: await _getHeaders(),
    );
    
    return await _handleResponse(response) ?? [];
  }
  
  Future<List<dynamic>> getOverdueTasks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl${AppConstants.tasks}/overdue'),
      headers: await _getHeaders(),
    );
    
    return await _handleResponse(response) ?? [];
  }
}