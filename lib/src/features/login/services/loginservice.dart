import 'package:dio/dio.dart';
import 'package:eshodhan/src/features/login/models/loginresponse.dart';
import 'package:eshodhan/src/utils/config/dio/dio_client.dart';
import 'package:eshodhan/src/utils/constants/endpoints.dart';
import 'package:eshodhan/src/utils/helpers/auth_helper.dart';

Future<LoginResponseModel> loginUser(String username, String password) async {
  try {
    final response = await dioClient.post(
      ApiEndpoints.loginUrl,
      data: {"username": username, "password": password},
    );

    final loginResponse = LoginResponseModel.fromJson(response.data);

    // Save token + user info securely
    await AuthHelper.saveAuthDetails(
      AuthDetails(
        token: loginResponse.token,
        userEmail: loginResponse.userEmail,
        userNiceName: loginResponse.userNiceName,
        userDisplayName: loginResponse.userDisplayName,
      ),
    );

    print('Login successful: ${loginResponse.userEmail}');
    return loginResponse;
  } on DioException catch (err) {
    logger.e("Login error: $err");
    if (err.response?.statusCode == 403) {
      throw (("Invalid credentials"));
    }
    throw (("Login failed: ${err.message}"));
  }
}
