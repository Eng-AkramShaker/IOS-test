// -----------------------------------------------------------------------
/// UserData — wrapper around the full API response
library;

// -----------------------------------------------------------------------

class UserData {
  final bool? success;
  final UserModel? userModel;
  final String? message;

  UserData({this.success, this.userModel, this.message});

  factory UserData.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return UserData(
      success: json['success'] as bool?,
      userModel: json['data'] != null
          ? UserModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': userModel?.toJson(),
    'message': message,
  };
}

// -----------------------------------------------------------------------

class UserModel {
  final num? userId;
  final String? userName;
  final String? fullName;
  final String? email;
  final String? sessionId;
  final String? expDate;
  final num? partnerId;
  final String? apiToken;

  UserModel({
    this.userId,
    this.userName,
    this.fullName,
    this.email,
    this.sessionId,
    this.expDate,
    this.partnerId,
    this.apiToken,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return UserModel(
      userId: json['user_id'] as num?,
      userName: json['user_name'] as String?,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      sessionId: json['session_id'] as String?,
      expDate: json['exp_date'] as String?,
      partnerId: json['partner_id'] as num?,
      apiToken: json['api_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'user_name': userName,
    'full_name': fullName,
    'email': email,
    'session_id': sessionId,
    'exp_date': expDate,
    'partner_id': partnerId,
    'api_token': apiToken,
  };
}
