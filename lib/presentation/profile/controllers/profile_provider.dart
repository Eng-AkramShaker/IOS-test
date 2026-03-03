// ignore_for_file: non_constant_identifier_names, prefer_final_fields

import 'package:buynuk/core/app/widgets/showSnackBar.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/core/services/prefe_service.dart';
import 'package:buynuk/presentation/profile/domain/models/profile_model.dart';
import 'package:buynuk/presentation/profile/domain/services/profile_service.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService;

  ProfileProvider({required ProfileService profileService}) : _profileService = profileService;

  // ── State ────────────────────────────────────────────────────────────────

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserProfile? _userProfileModel;
  UserProfile? get userProfileModel => _userProfileModel;

  bool _isLoadingchangePassword = false;
  bool get isLoadingChangePassword => _isLoadingchangePassword;

  // ── getProfile ───────────────────────────────────────────────────────────

  Future<UserProfile?> getProfile() async {
    _isLoading = true;
    _errorMessage = null;

    _notify();

    try {
      _userProfileModel = await _profileService.getProfile();
      return _userProfileModel;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('getProfile Error: $e');
      return null;
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  // ── editProfile ──────────────────────────────────────────────────────────

  Future<void> editProfile({
    required String name,
    required String mobile,
    required String street,
    required String city,
    required String zip,
  }) async {
    _isSaving = true;
    _notify();

    try {
      final updatedProfile = UserProfile(
        userId: _userProfileModel?.userId,
        name: name,
        userName: _userProfileModel?.userName,
        email: _userProfileModel?.email,
        phone: _userProfileModel?.phone,
        mobile: mobile,
        street: street,
        city: city,
        zip: zip,
        countryId: _userProfileModel?.countryId,
        countryName: _userProfileModel?.countryName,
        stateId: _userProfileModel?.stateId,
        stateName: _userProfileModel?.stateName,
      );

      await _profileService.editProfile(updatedProfile);

      _userProfileModel = updatedProfile;
      ShowSnackBar.success('profileUpdated'.tr);
      pop();
    } catch (e) {
      debugPrint('editProfile Error: $e');
      ShowSnackBar.error('profileError'.tr);
    } finally {
      _isSaving = false;
      _notify();
    }
  }

  // ─── changePassword ──────────────────────────────────────────────────────

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isSaving = true;
    _isLoadingchangePassword = true;
    _notify();

    try {
      if (newPassword != confirmPassword) {
        ShowSnackBar.error('passwordsDoNotMatch'.tr);
        return;
      }
      await _profileService.changePassword(oldPassword, newPassword);

      pop();
    } catch (e) {
      debugPrint('changePassword Error: $e');
    } finally {
      _isLoadingchangePassword = false;
      _isSaving = false;
      _notify();
    }
  }

  // ── logout ───────────────────────────────────────────────────────────────

  Future<void> logout() async {
    _isLoading = true;
    _notify();

    try {
      await _profileService.logout();

      // ✅ مسح البيانات المحفوظة
      await PrefsService.remove('email');
      await PrefsService.remove('password');
      await PrefsService.remove('token');

      await pushRemoveUntil(AppRoutes.login);
    } catch (e) {
      debugPrint('logout Error: $e');
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  // ── Helper ───────────────────────────────────────────────────────────────

  bool _disposed = false;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
