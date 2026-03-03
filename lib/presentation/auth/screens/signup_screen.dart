import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/app/widgets/showSnackBar.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/auth/controllers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // -----------------------------------------------------------------------

  String _passwordStrengthText(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'weak'.tr;
    if (password.length < 8) return 'good'.tr;
    return 'great'.tr;
  }

  Color _passwordStrengthColor(String password) {
    if (password.isEmpty) return Colors.grey;
    if (password.length < 6) return Colors.red;
    if (password.length < 8) return Colors.orange;
    return Colors.green;
  }

  int _passwordStrengthBars(String password) {
    if (password.isEmpty) return 0;
    if (password.length < 6) return 1;
    if (password.length < 8) return 2;
    return 3;
  }

  // -----------------------------------------------------------------------

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      ShowSnackBar.error('pleaseAgreeTerms'.tr);
      return;
    }

    await context.read<AuthProvider>().signup();
  }

  // -----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),

                /// Logo
                Image.asset("assets/images/logo2.png", width: 80),

                const SizedBox(height: 16),

                /// Title
                Text('createAccount'.tr, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

                const SizedBox(height: 6),

                Text('signUpSubtitle'.tr, textAlign: TextAlign.center),

                const SizedBox(height: 24),

                // ── Full Name ────────────────────────────────────────────
                _buildField(
                  label: 'fullName'.tr,
                  hint: 'enterName'.tr,
                  controller: provider.nameController,
                  icon: Icons.person,
                  validator: (v) => v!.isEmpty ? 'enterName'.tr : null,
                ),

                const SizedBox(height: 16),

                // ── Email ────────────────────────────────────────────────
                _buildField(
                  label: 'email'.tr,
                  hint: 'enterEmail'.tr,
                  controller: provider.emailController,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v!.contains('@') ? null : 'emailInvalid'.tr,
                ),

                const SizedBox(height: 16),

                // ── Phone ────────────────────────────────────────────────
                _buildField(
                  label: 'phone'.tr,
                  hint: '07701234567',
                  controller: provider.phoneController,
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'enterPhone'.tr : null,
                ),

                const SizedBox(height: 16),

                // ── Password ─────────────────────────────────────────────
                _buildField(
                  label: 'password'.tr,
                  hint: 'enterPassword'.tr,
                  controller: provider.passwordController,
                  icon: Icons.lock,
                  obscure: _obscurePassword,
                  suffix: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) => v!.length < 6 ? 'passwordTooShort'.tr : null,
                ),

                _buildPasswordStrength(provider.passwordController.text),

                const SizedBox(height: 16),

                // ── Confirm Password ─────────────────────────────────────
                _buildField(
                  label: 'confirmPassword'.tr,
                  hint: 'confirmYourPassword'.tr,
                  controller: _confirmPasswordController,
                  icon: Icons.lock,
                  obscure: _obscureConfirmPassword,
                  suffix: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (v) => v == provider.passwordController.text ? null : 'passwordsNotMatch'.tr,
                ),

                _buildTerms(),

                const SizedBox(height: 20),

                _buildButton(provider),

                const SizedBox(height: 20),

                _buildLoginLink(isRTL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------

  Widget _buildPasswordStrength(String password) {
    if (password.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          ...List.generate(
            3,
            (i) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 4,
                color: i < _passwordStrengthBars(password)
                    ? _passwordStrengthColor(password)
                    : Colors.grey[300],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "${'passwordStrength'.tr}: ${_passwordStrengthText(password)}",
            style: TextStyle(color: _passwordStrengthColor(password)),
          ),
        ],
      ),
    );
  }

  Widget _buildTerms() {
    return Row(
      children: [
        Checkbox(value: _agreeToTerms, onChanged: (v) => setState(() => _agreeToTerms = v!)),
        Text('agreeWith'.tr),
        const SizedBox(width: 4),
        Text('termsConditions'.tr, style: const TextStyle(color: AppColors.primary)),
      ],
    );
  }

  Widget _buildButton(AuthProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: provider.isLoading ? null : _signUp,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
        child: provider.isLoading
            ? const LoadingWidget(size: 20)
            : Text(
                'signUp'.tr,
                style: const TextStyle(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildLoginLink(bool isRTL) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('alreadyHaveAccount'.tr),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
          child: Text('signIn'.tr, style: const TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon), suffixIcon: suffix),
        ),
      ],
    );
  }
}
