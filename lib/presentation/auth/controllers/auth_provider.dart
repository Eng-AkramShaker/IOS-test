// ignore_for_file: prefer_final_fields

import 'package:buynuk/core/app/widgets/showSnackBar.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/core/services/prefe_service.dart';
import 'package:buynuk/presentation/auth/domain/models/login_model.dart';
import 'package:buynuk/presentation/auth/domain/models/signup_model.dart';
import 'package:buynuk/presentation/auth/domain/services/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService;

  AuthProvider({required this.authService});

  // -----------------------------------------------------------------------
  /// State
  // -----------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoginLoading = false;
  bool _isGuestLoading = false;

  bool get isLoginLoading => _isLoginLoading;
  bool get isGuestLoading => _isGuestLoading;

  String? _error;
  String? get error => _error;

  UserModel? _user;
  UserModel? get user => _user;

  String? _token;
  String? get token => _token;

  bool _isGuest = false;
  bool get isGuest => _isGuest;

  bool get isLoggedIn => _token != null && _token!.isNotEmpty && !_isGuest;

  // -----------------------------------------------------------------------
  /// Form Controllers
  // -----------------------------------------------------------------------

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // -----------------------------------------------------------------------

  void Function()? onLoginSuccess;
  void Function(String error)? onLoginError;
  void Function()? onSignupSuccess;
  void Function(String error)? onSignupError;

  final bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  // -----------------------------------------------------------------------
  /// Load Auth State (Token + Guest)
  // -----------------------------------------------------------------------

  Future<void> loadAuthState() async {
    final savedToken = await PrefsService.getString('api_token');

    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
      _isGuest = false;
      await PrefsService.remove('is_guest');
    } else {
      _token = null;
      _user = null;
      _isGuest = await PrefsService.getBool('is_guest') ?? false;
    }

    notifyListeners();
  }

  // -----------------------------------------------------------------------
  /// Login as Guest
  // -----------------------------------------------------------------------

  Future<void> loginAsGuest() async {
    _isGuestLoading = true;
    notifyListeners();

    try {
      await PrefsService.setBool('is_guest', true);
      _isGuest = true;
      _user = null;
      _token = null;

      _isGuestLoading = false;
      notifyListeners();

      await pushRemoveUntil(AppRoutes.mainNavigation);
      ShowSnackBar.success("welcomeAsGuest".tr);
    } catch (e) {
      _isGuestLoading = false;
      notifyListeners();

      ShowSnackBar.error("guestLoginFailed".tr);
    }
  }

  // -----------------------------------------------------------------------
  /// Login
  // -----------------------------------------------------------------------

  Future<void> login({required String email, required String password}) async {
    _isLoginLoading = true;
    notifyListeners();

    try {
      final userData = await authService.login(email: email, password: password);

      if (userData.success == true && userData.userModel != null) {
        _user = userData.userModel;
        _token = userData.userModel!.apiToken;

        if (_token != null) {
          await PrefsService.setString("api_token", _token!);
          await PrefsService.setString("email", email);
          await PrefsService.setString("password", password);
          await PrefsService.remove('is_guest');
          _isGuest = false;
        }

        _isLoginLoading = false;
        notifyListeners();

        await pushRemoveUntil(AppRoutes.mainNavigation);
        onLoginSuccess?.call();
      } else {
        _isLoginLoading = false;
        notifyListeners();

        final msg = userData.message ?? "Login failed";
        ShowSnackBar.error(msg);
        onLoginError?.call(msg);
      }
    } catch (e) {
      _isLoginLoading = false;
      notifyListeners();

      ShowSnackBar.error("Unexpected error");
    }
  }

  // -----------------------------------------------------------------------
  /// Signup
  // -----------------------------------------------------------------------

  Future<void> signup() async {
    _setLoading(true);
    _clearError();

    try {
      final SignupModel signupData = await authService.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phone: phoneController.text.trim(),
      );

      if (signupData.success == true) {
        debugPrint("✅ Account created: ${signupData.userModel?.email}");

        _setLoading(false);
        ShowSnackBar.success("accountCreatedSuccessfully".tr);

        await pushRemoveUntil(AppRoutes.login);

        onSignupSuccess?.call();
      } else {
        final String msg = signupData.message ?? "signupFailed".tr;
        _setError(msg);
        _setLoading(false);
        ShowSnackBar.error(msg);
        onSignupError?.call(msg);
      }
    } catch (e) {
      const String msg = "unexpectedError";
      _setError(msg);
      _setLoading(false);
      ShowSnackBar.error("accountCreationFailed".tr);
      onSignupError?.call(msg);
    }
  }
  // -----------------------------------------------------------------------
  /// Forgot Password
  // -----------------------------------------------------------------------

  Future<void> forgotPassword({required String email}) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await authService.forgotPassword(email: email);

      _setLoading(false);

      if (result['success'] == true) {
        ShowSnackBar.success("passwordResetEmailSent".tr);
      } else {
        ShowSnackBar.error("failedToSendResetEmail".tr);
      }
    } catch (e) {
      _setLoading(false);
      ShowSnackBar.error("failedToSendResetEmail".tr);
      debugPrint("❌ forgotPassword error: $e");
    }
  }

  // -----------------------------------------------------------------------
  /// Logout
  // -----------------------------------------------------------------------

  Future<void> logout() async {
    _setLoading(true);

    try {
      if (!_isGuest) {
        await _logoutFromServer();
      }

      await _clearLocalData();
      _resetState();

      _setLoading(false);

      await pushRemoveUntil(AppRoutes.login);

      ShowSnackBar.success("logoutSuccess".tr);
    } catch (e) {
      debugPrint("❌ Logout error: $e");

      await _clearLocalData();
      _resetState();
      _setLoading(false);

      await pushRemoveUntil(AppRoutes.login);
    }
  }

  // -----------------------------------------------------------------------
  /// Logout من السيرفر
  // -----------------------------------------------------------------------

  Future<void> _logoutFromServer() async {
    try {
      await authService.logout();
      debugPrint("✅ Token revoked on server");
    } catch (e) {
      debugPrint("⚠️ Failed to revoke token on server: $e");
    }
  }

  // -----------------------------------------------------------------------
  /// مسح البيانات المحلية
  // -----------------------------------------------------------------------

  Future<void> _clearLocalData() async {
    await PrefsService.remove("api_token");
    await PrefsService.remove("email");
    await PrefsService.remove("password");
    await PrefsService.remove("user_data");
    await PrefsService.remove("is_guest");
    debugPrint("✅ Local data cleared");
  }

  // -----------------------------------------------------------------------
  /// إعادة تعيين الحالة
  // -----------------------------------------------------------------------

  void _resetState() {
    _user = null;
    _token = null;
    _error = null;
    _isGuest = false;
    onLoginSuccess = null;
    onLoginError = null;
    onSignupSuccess = null;
    onSignupError = null;

    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();

    notifyListeners();
  }

  // -----------------------------------------------------------------------
  /// Dispose
  // -----------------------------------------------------------------------

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // -----------------------------------------------------------------------
  /// Helpers
  // -----------------------------------------------------------------------

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
