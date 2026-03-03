import 'dart:io';
import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/app/widgets/show_isGuest_Dialog.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/auth/controllers/auth_provider.dart';
import 'package:buynuk/presentation/language/languageScreen.dart';
import 'package:buynuk/presentation/profile/controllers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../help_support/screens/help_support_screen.dart';
import '../security_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profilePhoto;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      // ✅ تحميل البروفايل فقط إذا لم يكن زائر
      if (!authProvider.isGuest) {
        context.read<ProfileProvider>().getProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: buildAppBar(context, "profile".tr),

        body: Consumer2<ProfileProvider, AuthProvider>(
          builder: (context, profileProvider, authProvider, _) {
            final bool isGuest = authProvider.isGuest;

            return Column(
              children: [
                profileProvider.isLoading && !isGuest
                    ? const Expanded(child: Center(child: LoadingWidget()))
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),

                                _buildProfileSection(
                                  isGuest ? 'guest'.tr : (profileProvider.userProfileModel?.name ?? "Guest"),
                                  isGuest,
                                ),
                                const SizedBox(height: 30),

                                _buildActionButtons(),
                                const SizedBox(height: 50),

                                _buildGeneralSettingsSection(context, profileProvider, authProvider),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileSection(String name, bool isGuest) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: _profilePhoto != null && _profilePhoto!.existsSync()
              ? ClipOval(
                  child: Image.file(
                    _profilePhoto!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.person, size: 38, color: Colors.grey[400]),
                  ),
                )
              : Icon(isGuest ? Icons.person_outline : Icons.person, size: 38, color: Colors.grey[400]),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        // ✅ عرض رسالة للزائر
        if (isGuest) ...[
          const SizedBox(height: 4),
          Text('loginForFullAccess'.tr, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.phone,
              label: 'helpSupport'.tr,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettingsSection(
    BuildContext context,
    ProfileProvider profileProvider,
    AuthProvider authProvider,
  ) {
    final bool isGuest = authProvider.isGuest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'generalSettings'.tr,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 8),

        // ✅ إذا كان زائر، اعرض زر تسجيل الدخول
        if (isGuest) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                push(AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.login, color: Colors.white),
              label: Text(
                'loginNow'.tr,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // ✅ المعلومات الشخصية (محمية)
        _buildListTile(
          icon: Icons.person_outline,
          title: 'personalInfo'.tr,
          onTap: isGuest
              ? () => show_isGuest_Dialog(context)
              : () async {
                  push(AppRoutes.personalInfoScreen);
                },
        ),

        // ✅ الطلبات (محمية)
        _buildListTile(
          icon: Icons.shopping_bag_outlined,
          title: 'myOrders'.tr,
          onTap: isGuest
              ? () => show_isGuest_Dialog(context)
              : () {
                  push(AppRoutes.ordersScreen, arguments: true);
                },
        ),

        // ✅ اللغة (متاحة للجميع)
        _buildListTile(
          icon: Icons.language_outlined,
          title: "language".tr,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LanguageScreen(fromProfile: true)),
            );
            if (result == true) {
              setState(() {});
            }
          },
        ),

        // ✅ الأمان (محمية)
        _buildListTile(
          icon: Icons.lock_outline,
          title: 'securitySettings'.tr,
          onTap: isGuest
              ? () => show_isGuest_Dialog(context)
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()),
                  );
                },
        ),

        // ✅ المساعدة (متاحة للجميع)
        _buildListTile(
          icon: Icons.help_outline,
          title: 'helpSupport'.tr,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()));
          },
        ),

        Divider(height: 20, thickness: 1, color: Colors.grey[300], indent: 20, endIndent: 20),

        // ✅ تسجيل الخروج
        _buildListTile(
          icon: Icons.logout,
          title: isGuest ? 'exitGuestMode'.tr : 'signOut'.tr,
          onTap: () => _showSignOutDialog(context, profileProvider, authProvider),
          iconColor: Colors.red,
          textColor: Colors.red,
          arrowColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? arrowColor,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconColor != null ? iconColor.withValues(alpha: 0.1) : Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: iconColor ?? Colors.black87, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textColor ?? Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: arrowColor ?? Colors.grey[400], size: 18),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------

  void _showSignOutDialog(BuildContext context, ProfileProvider profileProvider, AuthProvider authProvider) {
    final bool isGuest = authProvider.isGuest;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isGuest ? 'exitGuestMode'.tr : 'logout'.tr,
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 16),
                Text(
                  isGuest ? 'exitGuestModeConfirmation'.tr : 'logoutConfirmation'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          'cancel'.tr,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          pop();
                          if (isGuest) {
                            authProvider.logout();
                          } else {
                            profileProvider.logout();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text(
                          'confirm'.tr,
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
