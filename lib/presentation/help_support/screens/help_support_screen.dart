import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/app/widgets/showSnackBar.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/help_support/screens/legal_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: buildAppBar(context, "helpSupport".tr, showBottom: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Section ───────────────────────────────
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.help_outline, size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'hereToHelp'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'supportTeamMessage'.tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // ─── Contact Us Section ───────────────────────────
            _buildSectionTitle('contactUs'.tr),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.phone,
              title: 'callUs'.tr,
              subtitle: '0535944959',
              onTap: () {},
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.email,
              title: 'emailUs'.tr,
              subtitle: 'info@buynuk.com',
              onTap: () {},
              color: AppColors.primary,
            ),

            const SizedBox(height: 40),

            // ─── FAQ Section ──────────────────────────────────
            _buildSectionTitle('faq'.tr),
            const SizedBox(height: 16),
            _buildFAQItem(question: 'faqTrackOrder'.tr, answer: 'faqTrackOrderAnswer'.tr),
            _buildFAQItem(question: 'faqReturnPolicy'.tr, answer: 'faqReturnPolicyAnswer'.tr),
            _buildFAQItem(question: 'faqShippingTime'.tr, answer: 'faqShippingTimeAnswer'.tr),
            _buildFAQItem(question: 'faqChangePassword'.tr, answer: 'faqChangePasswordAnswer'.tr),
            _buildFAQItem(question: 'faqCancelOrder'.tr, answer: 'faqCancelOrderAnswer'.tr),
            const SizedBox(height: 40),

            // ─── Additional Resources ─────────────────────────
            _buildSectionTitle('additionalResources'.tr),
            const SizedBox(height: 16),
            _buildResourceCard(
              icon: Icons.description_outlined,
              title: 'termsConditions'.tr,
              onTap: () {
                push(AppRoutes.legalScreen, arguments: "terms");
              },
            ),
            const SizedBox(height: 12),
            _buildResourceCard(
              icon: Icons.privacy_tip_outlined,
              title: 'privacyPolicy'.tr,
              onTap: () {
                push(AppRoutes.legalScreen, arguments: "privacy");
              },
            ),
            const SizedBox(height: 12),
            _buildResourceCard(
              icon: Icons.info_outline,
              title: 'aboutUs'.tr,
              onTap: () {
                ShowSnackBar.info('aboutComingSoon'.tr);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ─── Section Title ─────────────────────────────────────────

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  // ─── Contact Card ──────────────────────────────────────────

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  // ─── FAQ Item ──────────────────────────────────────────────

  Widget _buildFAQItem({required String question, required String answer}) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      title: Text(
        question,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      iconColor: AppColors.primary,
      collapsedIconColor: Colors.grey[600],
      children: [
        Text(answer, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700], height: 1.5)),
      ],
    );
  }

  // ─── Resource Card ─────────────────────────────────────────

  Widget _buildResourceCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
