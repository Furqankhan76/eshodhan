import 'package:logger/logger.dart';

class ApiEndpoints {
  static const String loginUrl = "/wp-json/jwt-auth/v1/token";
  static const String registerUrl = "/wp-json/api/v1/register";
  static const String forgotPassword = '/wp-json/api/v1/forgot-password';
}

// logger is used for logging errors
final logger = Logger();
