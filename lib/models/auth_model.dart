import 'package:equatable/equatable.dart';

class AuthRequest {
  final String username;
  final String email;
  final String password;

  AuthRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
  };
}

class AuthResponse extends Equatable {
  final String token;
  final String type;
  final int userId;
  final String username;
  final String email;
  final DateTime createdAt;

  const AuthResponse({
    required this.token,
    required this.type,
    required this.userId,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      type: json['type'] ?? 'Bearer',
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  List<Object> get props => [token, userId, username, email, createdAt];
}