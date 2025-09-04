class AuthResponseModel {
  String? message;
  String? status;

  AuthResponseModel({this.message, this.status});

  AuthResponseModel.fromJson(Map<String, dynamic> json) {
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["message"] = message;
    data["status"] = status;
    return data;
  }
}
