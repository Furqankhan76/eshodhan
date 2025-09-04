import 'package:dio/dio.dart';
import 'package:eshodhan/src/features/signup/models/signup_model.dart';
import 'package:eshodhan/src/features/login/models/loginresponse.dart';
import 'package:eshodhan/src/features/login/services/loginservice.dart'; // Import your existing login function
import 'package:eshodhan/src/utils/config/dio/dio_client.dart';
import 'package:eshodhan/src/utils/constants/endpoints.dart';

class SignupService {
  // Register user only
  static Future<SignupResponseModel> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.registerUrl, // Add this to your endpoints
        data: {"username": name, "email": email, "password": password},
      );

      final registerResponse = SignupResponseModel.fromJson(response.data);
      print('Registration successful: User ID ${registerResponse.userId}');
      return registerResponse;
    } on DioException catch (dioErr) {
     print("Registration DioException: ${dioErr.response?.data['message']}");

      // Handle specific error responses
      if (dioErr.response?.data != null) {
        try {
          final errorResponse = SignupErrorModel.fromJson(
            dioErr.response!.data,
          );
          if (errorResponse.code == "user_exists") {
            throw Exception("Username or email already exists");
          }
          print(Exception('ffdf ${errorResponse}'));
          throw Exception(errorResponse.message);
        } catch (parseError) {
          // Fallback if error parsing fails
          throw ("$parseError");
        }
      }

      throw Exception("Registration failed: ${dioErr.message}");
    } catch (err) {
      print("Registration error: $err");
      throw Exception("Registration failed: $err");
    }
  }

  // Combined register + auto-login using existing login function
  static Future<LoginResponseModel> registerAndLogin({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Step 1: Register user
      await registerUser(name: name, email: email, password: password);

      print('Registration successful for user: $email');

      // Step 2: Auto-login using your existing login function
      final loginResponse = await loginUser(email, password);

      return loginResponse;
    } catch (err) {
      print("Register + Login error: $err");
      rethrow; // Re-throw to maintain original error message
    }
  }
}
