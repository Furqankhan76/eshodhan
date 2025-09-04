class LoginResponseModel {
  String? token;
  String? userEmail;
  String? userNiceName;
  String? userDisplayName;

  LoginResponseModel({
    this.token,
    this.userEmail,
    this.userNiceName,
    this.userDisplayName,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    if (json["token"] is String) {
      token = json["token"];
    }
    if (json["user_email"] is String) {
      userEmail = json["user_email"];
    }
    if (json["user_nicename"] is String) {
      userNiceName = json["user_nicename"];
    }
    if (json["user_display_name"] is String) {
      userDisplayName = json["user_display_name"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["token"] = token;
    data["user_email"] = userEmail;
    data["user_nicename"] = userNiceName;
    data["user_display_name"] = userDisplayName;
    return data;
  }
}
