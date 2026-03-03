import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/profile/controllers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ProfileProvider>().getProfile();
      _fillControllers();
    });
  }

  void _fillControllers() {
    final profile = context.read<ProfileProvider>().userProfileModel;
    if (profile == null) return;

    _nameController.text = profile.name ?? '';
    _emailController.text = profile.email ?? '';
    _phoneController.text = profile.phone ?? '';
    _mobileController.text = profile.mobile ?? '';
    _streetController.text = profile.street ?? '';
    _cityController.text = profile.city ?? '';
    _zipController.text = profile.zip ?? '';
    _countryController.text = profile.countryName ?? '';
    _stateController.text = profile.stateName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: buildAppBar(context, "personalInfo".tr, showBottom: true),

            body: Column(
              children: [
                provider.isLoading
                    ? Expanded(child: const Center(child: LoadingWidget()))
                    : Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),

                                // ── Name ─────────────────────────────────────────
                                _buildField(
                                  label: 'fullName'.tr,
                                  controller: _nameController,
                                  hint: 'enterFullName'.tr,
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty ? 'pleaseEnterName'.tr : null,
                                ),

                                // ── Email (disabled) ──────────────────────────────
                                _buildField(
                                  label: 'email'.tr,
                                  controller: _emailController,
                                  hint: 'enterEmail'.tr,
                                  enabled: false,
                                  note: 'emailCannotChange'.tr,
                                ),

                                // ── Phone (disabled) ──────────────────────────────
                                _buildField(
                                  label: 'phoneNumber'.tr,
                                  controller: _phoneController,
                                  hint: 'enterPhoneNumber'.tr,
                                  enabled: false,
                                  note: 'phoneCannotChange'.tr,
                                ),

                                // ── Mobile ────────────────────────────────────────
                                _buildField(
                                  label: 'mobile'.tr,
                                  controller: _mobileController,
                                  hint: 'enterMobile'.tr,
                                  keyboardType: TextInputType.phone,
                                ),

                                // ── Street ────────────────────────────────────────
                                _buildField(
                                  label: 'street'.tr,
                                  controller: _streetController,
                                  hint: 'enterStreet'.tr,
                                ),

                                // ── City ──────────────────────────────────────────
                                _buildField(
                                  label: 'city'.tr,
                                  controller: _cityController,
                                  hint: 'enterCity'.tr,
                                ),

                                // ── Zip ───────────────────────────────────────────
                                _buildField(
                                  label: 'zip'.tr,
                                  controller: _zipController,
                                  hint: 'enterZip'.tr,
                                  keyboardType: TextInputType.number,
                                ),

                                // ── Country (disabled - يتغير من شاشة منفصلة) ────
                                _buildField(
                                  label: 'country'.tr,
                                  controller: _countryController,
                                  hint: 'selectCountry'.tr,
                                  enabled: false,
                                ),

                                // ── State (disabled - يتغير من شاشة منفصلة) ──────
                                _buildField(
                                  label: 'state'.tr,
                                  controller: _stateController,
                                  hint: 'selectState'.tr,
                                  enabled: false,
                                ),

                                const SizedBox(height: 16),

                                // ── Save Button ───────────────────────────────────
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: provider.isSaving
                                        ? null
                                        : () {
                                            if (!_formKey.currentState!.validate()) return;
                                            context.read<ProfileProvider>().editProfile(
                                              name: _nameController.text.trim(),
                                              mobile: _mobileController.text.trim(),
                                              street: _streetController.text.trim(),
                                              city: _cityController.text.trim(),
                                              zip: _zipController.text.trim(),
                                            );
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: provider.isSaving
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : Text(
                                            'saveChanges'.tr,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Widget مساعد للحقول ───────────────────────────────────────────────────

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool enabled = true,
    String? note,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
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
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: GoogleFonts.poppins(fontSize: 14, color: enabled ? Colors.black87 : Colors.grey[600]),
        ),
        if (note != null) ...[
          const SizedBox(height: 6),
          Text(note, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
        ],
        const SizedBox(height: 20),
      ],
    );
  }
}
