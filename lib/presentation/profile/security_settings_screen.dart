import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/auth/controllers/auth_provider.dart';
import 'package:buynuk/presentation/profile/controllers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    // if (!_formKey.currentState!.validate()) return;

    final profileProvider = context.read<ProfileProvider>();

    await profileProvider.changePassword(
      oldPassword: _currentPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: buildAppBar(context, "securitySettings".tr, showBottom: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildPasswordField(
                label: 'currentPassword'.tr,
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                onToggle: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
                hint: 'enterCurrentPassword'.tr,
                errorMessage: 'enterCurrentPasswordError'.tr,
              ),
              const SizedBox(height: 24),
              _buildPasswordField(
                label: 'newPassword'.tr,
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                onToggle: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                hint: 'enterNewPassword'.tr,
                errorMessage: 'enterNewPasswordError'.tr,
                minLength: 6,
              ),
              const SizedBox(height: 24),
              _buildPasswordField(
                label: 'confirmNewPassword'.tr,
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                hint: 'confirmYourNewPassword'.tr,
                errorMessage: 'confirmNewPasswordError'.tr,
                matchController: _newPasswordController,
              ),
              const SizedBox(height: 40),
              _buildSubmitButton(),
              const SizedBox(height: 20),
              _buildInfoBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: AppColors.primary, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'changePassword'.tr,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'updatePasswordSecure'.tr,
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required String hint,
    required String errorMessage,
    int? minLength,
    TextEditingController? matchController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
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
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: Colors.grey[600],
              ),
              onPressed: onToggle,
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return errorMessage;
            }
            if (minLength != null && value.length < minLength) {
              return 'passwordMinLength'.tr;
            }
            if (matchController != null && value != matchController.text.trim()) {
              return 'passwordsDoNotMatch'.tr;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: provider.isLoadingChangePassword ? null : _changePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: provider.isLoadingChangePassword
                ? const LoadingWidget(size: 20)
                : Text(
                    'changePassword'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'passwordInfo'.tr,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue[900], height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
