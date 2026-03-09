class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api';
  
  // For Android Emulator, use 10.0.2.2
  // For real devices, use your computer's local IP
  static const String androidBaseUrl = 'http://10.0.2.2:3000/api';

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';
  static const String pets = '/pets';
}
