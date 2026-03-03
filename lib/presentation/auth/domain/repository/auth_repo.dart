// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:buynuk/core/app/widgets/showSnackBar.dart';
import 'package:buynuk/core/services/api_service.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/prefe_service.dart';
import 'package:buynuk/presentation/auth/domain/models/login_model.dart';
import 'package:buynuk/presentation/auth/domain/models/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  // -----------------------------------------------------------------------
  /// Login
  // -----------------------------------------------------------------------

  Future<UserData> login({required String email, required String password}) async {
    // Build request body
    final Map<String, String> data = {"email": email, "password": password};

    // Attach guest id if available
    final guestId = await PrefsService.getString("guest_id");
    if (guestId != null && guestId.isNotEmpty) {
      data["guest_id"] = guestId;
    }

    final http.Response response = await apiClient.postData(AppConstants.loginUri, data, handleError: false);

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      ShowSnackBar.success('loginSuccess'.tr);
      return UserData.fromJson(json);
    } else {
      final Map<String, dynamic> json = jsonDecode(response.body);
      ShowSnackBar.error('loginFailed'.tr);
      return UserData.fromJson(json);
    }
  }

  // -----------------------------------------------------------------------
  /// Signup
  // -----------------------------------------------------------------------

  Future<SignupModel> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final Map<String, String> data = {"name": name, "user_name": email, "password": password, "phone": phone};

    final http.Response response = await apiClient.postData(AppConstants.signupUri, data, handleError: false);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return SignupModel.fromJson(json);
  }

  // -----------------------------------------------------------------------
  /// Forgot Password
  // -----------------------------------------------------------------------

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final Map<String, String> data = {"login": email};

      final http.Response response = await apiClient.postData(
        AppConstants.forgotPasswordUri,
        data,
        handleError: false,
      );

      final Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 200 && json['success'] == true) {
        debugPrint("✅ Password reset email sent");
        return json;
      } else {
        debugPrint("⚠️ Forgot password failed: ${json['message']}");
        throw Exception(json['message'] ?? 'Failed to send reset email');
      }
    } catch (e) {
      debugPrint("❌ forgotPassword error: $e");
      rethrow;
    }
  }

  // -----------------------------------------------------------------------
  /// Logout
  // -----------------------------------------------------------------------

  Future<void> logout() async {
    try {
      final http.Response response = await apiClient.postData(AppConstants.logoutUri, {});

      final Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 200 && json['success'] == true) {
        debugPrint("✅ Logout successful on server");
      } else {
        throw Exception(json['message'] ?? 'Logout failed');
      }
    } catch (e) {
      debugPrint("❌ Logout API error: $e");
      rethrow;
    }
  }
}
