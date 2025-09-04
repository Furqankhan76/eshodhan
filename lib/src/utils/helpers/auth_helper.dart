import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthDetails {
  final String? token;
  final String? userEmail;
  final String? userNiceName;
  final String? userDisplayName;

  AuthDetails({
    required this.token,
    required this.userEmail,
    required this.userNiceName,
    required this.userDisplayName,
  });

  factory AuthDetails.fromJson(Map<String, dynamic> json) {
    return AuthDetails(
      token: json['token'],
      userEmail: json['user_email'],
      userNiceName: json['user_nicename'],
      userDisplayName: json['user_display_name'],
    );
  }
}



class AuthHelper {
  static const storage = FlutterSecureStorage();

  // Save auth details after login
  static Future<void> saveAuthDetails(AuthDetails details) async {
    await storage.write(key: "token", value: details.token);
    await storage.write(key: "user_email", value: details.userEmail);
    await storage.write(key: "user_nicename", value: details.userNiceName);
    await storage.write(key: "user_display_name", value: details.userDisplayName);
  }

  // Get saved details
  static Future<AuthDetails?> getAuthDetails() async {
    final token = await storage.read(key: "token");
    if (token == null) return null;

    return AuthDetails(
      token: token,
      userEmail: await storage.read(key: "user_email"),
      userNiceName: await storage.read(key: "user_nicename"),
      userDisplayName: await storage.read(key: "user_display_name"),
    );
  }

  // Check if user logged in
  static Future<bool> isUserLoggedIn() async {
    final token = await storage.read(key: "token");
    return token != null;
  }

  // Clear user data (logout)
  static Future<void> logout() async {
    await storage.deleteAll();
  }
}
