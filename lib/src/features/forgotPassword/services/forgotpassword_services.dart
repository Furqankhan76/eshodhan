import 'package:dio/dio.dart';
import 'package:eshodhan/src/utils/config/dio/dio_client.dart';
import 'package:eshodhan/src/utils/constants/endpoints.dart';

class ForgotPasswordService {
  static Future<String> sendResetLink(String email) async {
    final response = await dioClient.post(
      ApiEndpoints.forgotPassword,
      data: {"email": email},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['message'] ?? "Password reset email sent";
    } else {
      throw Exception(response.data['message'] ?? "Something went wrong");
    }
  }
}
