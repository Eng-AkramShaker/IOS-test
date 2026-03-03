import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/auth/controllers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    await authProvider.forgotPassword(email: _emailController.text.trim());

    // ✅ إذا نجحت العملية، اعرض رسالة النجاح
    if (!authProvider.isLoading && mounted) {
      setState(() => _emailSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

                // ── Logo ──
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.asset("assets/images/logo2.png"),
                ),

                const SizedBox(height: 24),

                // ── Title ──
                Text('forgotPassword'.tr, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

                const SizedBox(height: 8),

                // ── Subtitle ──
                Text(
                  _emailSent ? 'checkEmailSubtitle'.tr : 'forgotSubtitle'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),

                const SizedBox(height: 40),

                if (!_emailSent) ...[
                  // ── Email Field ──
                  _buildField(
                    label: 'email'.tr,
                    hint: 'enterEmail'.tr,
                    controller: _emailController,
                    icon: Icons.email,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'emailRequired'.tr;
                      }

                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                      if (!emailRegex.hasMatch(v.trim())) {
                        return 'emailInvalid'.tr;
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // ── Send Button ──
                  Consumer<AuthProvider>(
                    builder: (_, auth, __) => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: auth.isLoading ? null : _sendReset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: auth.isLoading
                            ? const LoadingWidget(size: 24)
                            : Text(
                                'sendResetLink'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ] else ...[
                  // ── Success Icon ──
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle, color: Colors.green, size: 50),
                  ),

                  const SizedBox(height: 24),

                  Text('emailSent'.tr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 12),

                  Text(
                    "${'resetLinkSentTo'.tr} ${_emailController.text}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),

                  const SizedBox(height: 32),

                  // ── Back to Login Button ──
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        pushReplacement(AppRoutes.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'backToLogin'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // ── Back to Login Link ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('rememberPassword'.tr),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        pushReplacement(AppRoutes.login);
                      },
                      child: Text(
                        'signIn'.tr,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
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

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
