import 'package:buynuk/presentation/auth/domain/models/login_model.dart';
import 'package:buynuk/presentation/auth/domain/models/signup_model.dart';
import 'package:buynuk/presentation/auth/domain/repository/auth_repo.dart';

class AuthService {
  final AuthRepository authRepository;

  AuthService({required this.authRepository});

  // -----------------------------------------------------------------------
  /// Login
  // -----------------------------------------------------------------------

  Future<UserData> login({required String email, required String password}) async {
    return await authRepository.login(email: email, password: password);
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
    return await authRepository.signup(name: name, email: email, password: password, phone: phone);
  }

  // -----------------------------------------------------------------------
  /// Forgot Password
  // -----------------------------------------------------------------------

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    return await authRepository.forgotPassword(email: email);
  }

  // -----------------------------------------------------------------------
  /// Logout
  // -----------------------------------------------------------------------

  Future<void> logout() async {
    return await authRepository.logout();
  }
}
