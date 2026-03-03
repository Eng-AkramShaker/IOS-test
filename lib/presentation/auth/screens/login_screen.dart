import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/auth/controllers/auth_provider.dart';
import 'package:buynuk/presentation/auth/widget/textField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  child: Image.asset("assets/images/logo2.png"),
                ),

                const SizedBox(height: 24),

                Text('welcomeBack'.tr, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

                const SizedBox(height: 8),

                Text('signInContinue'.tr, style: TextStyle(fontSize: 14, color: Colors.grey[600])),

                const SizedBox(height: 40),

                buildTextField(
                  label: 'email'.tr,
                  hint: 'enterEmail'.tr,
                  controller: _emailController,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'emailRequired'.tr;
                    if (!v.contains('@')) return 'emailInvalid'.tr;
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                buildTextField(
                  label: 'password'.tr,
                  hint: 'enterPassword'.tr,
                  controller: _passwordController,
                  icon: Icons.lock,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'passwordRequired'.tr;
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                    ),
                    child: Text(
                      'forgotPassword'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Consumer<AuthProvider>(
                  builder: (_, auth, __) => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: auth.isLoginLoading ? null : _onLoginPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: auth.isLoginLoading
                          ? const LoadingWidget(size: 24)
                          : Text(
                              'signIn'.tr,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Consumer<AuthProvider>(
                  builder: (_, auth, __) => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: auth.isGuestLoading ? null : _onGuestPressed,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: auth.isGuestLoading
                          ? const LoadingWidget(size: 24)
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.person_outline, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  'continueAsGuest'.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('noAccount'.tr),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SignUpScreen()),
                      ),
                      child: Text(
                        'signUp'.tr,
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginPressed() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthProvider>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  void _onGuestPressed() {
    context.read<AuthProvider>().loginAsGuest();
  }
}
