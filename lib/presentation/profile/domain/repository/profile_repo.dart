// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:buynuk/core/app/widgets/showSnackBar.dart';
import 'package:buynuk/core/services/api_service.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/profile/domain/models/profile_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

class ProfileRepository {
  final ApiClient apiClient;

  ProfileRepository({required this.apiClient});

  // -----------------------------------------------------------------------
  ///  Get Profile
  // -----------------------------------------------------------------------

  Future<UserProfile> getProfile() async {
    try {
      final http.Response response = await apiClient.getData(AppConstants.profileUri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return UserProfile.fromJson(json);
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  // -----------------------------------------------------------------------
  ///  Edit Profile
  // -----------------------------------------------------------------------

  Future<void> editProfile(UserProfile profile) async {
    final http.Response response = await apiClient.putData(AppConstants.editProfileUri, profile.toJson());

    final Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode != 200 || json['success'] != true) {
      throw Exception(json['message'] ?? 'Failed to update profile');
    }
  }

  // -----------------------------------------------------------------------
  ///  Change Password
  // -----------------------------------------------------------------------

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final http.Response response = await apiClient.postData(AppConstants.changePasswordUri, {
      'old_password': oldPassword,
      'new_password': newPassword,
    });

    final Map<String, dynamic> json = jsonDecode(response.body);

    if (response.statusCode != 200 || json['success'] != true) {
      ShowSnackBar.error("failedToChangePassword".tr);

      throw Exception(json['message'] ?? 'Failed to change password');
    } else {
      pop();
      ShowSnackBar.success('passwordChangedSuccessfully'.tr);
    }
  }
  // -----------------------------------------------------------------------
  ///   logout
  // -----------------------------------------------------------------------

  Future<void> logout() async {
    final http.Response response = await apiClient.postData(AppConstants.logoutUri, {});
    if (response.statusCode == 200) {
      ShowSnackBar.success('logoutSuccess'.tr);
      return;
    } else {
      ShowSnackBar.error('logoutError'.tr);

      throw Exception('Failed to logout');
    }
  }
}
