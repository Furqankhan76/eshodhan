class SignupResponseModel {
  final bool success;
  final int userId;

  SignupResponseModel({
    required this.success,
    required this.userId,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      success: json['success'] ?? false,
      userId: json['user_id'] ?? 0,
    );
  }
}

class SignupErrorModel {
  final String code;
  final String message;
  final Map<String, dynamic>? data;

  SignupErrorModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory SignupErrorModel.fromJson(Map<String, dynamic> json) {
    return SignupErrorModel(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}