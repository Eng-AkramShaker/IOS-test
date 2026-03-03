class SignupModel {
  final bool? success;
  final String? message;
  final SignupUserModel? userModel;

  SignupModel({this.success, this.message, this.userModel});

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      success: json['success'] == true || json['success'] == 1,
      message: (json['message'] ?? json['error'])?.toString(),
      userModel: json['data'] != null ? SignupUserModel.fromJson(json['data']) : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class SignupUserModel {
  final int? id;
  final String? name;
  final String? userName;
  final String? email;
  final String? phone;
  final String? apiToken;

  SignupUserModel({this.id, this.name, this.userName, this.email, this.phone, this.apiToken});

  factory SignupUserModel.fromJson(Map<String, dynamic> json) {
    return SignupUserModel(
      id: json['user_id'] ?? json['id'], // ✅ السيرفر يرسل user_id
      name: json['name']?.toString(),
      userName: json['user_name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      apiToken: json['api_token']?.toString(), // سيكون null — السيرفر لا يرسله عند التسجيل
    );
  }
}
