import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get _host {
    if (kIsWeb) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get baseUrl => 'http://$_host:3000/api';
  static String get socketUrl => 'http://$_host:3000';

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String me = '/auth/me';
  static const String pets = '/pets';
  static const String interactions = '/interactions';
}
