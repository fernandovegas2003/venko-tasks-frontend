class AppConstants {
  static const String appName = 'Venko Tasks';
  static const String baseUrl = 'http://192.168.1.107:8080';
  
  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String tasks = '/tasks';
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
  static const String emailKey = 'email';
  
  // Task status
  static const String statusPending = 'PENDIENTE';
  static const String statusInProgress = 'EN_PROGRESO';
  static const String statusCompleted = 'COMPLETADA';
  static const String statusCancelled = 'CANCELADA';
  
  // Task priority
  static const String priorityLow = 'BAJA';
  static const String priorityMedium = 'MEDIA';
  static const String priorityHigh = 'ALTA';
  static const String priorityUrgent = 'URGENTE';
  
  // Validación
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
}