import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferEarnScreen extends StatelessWidget {
  const ReferEarnScreen({super.key});

  String _getReferralCode() {
    return 'REF12345';
  }

  Future<void> _copyReferralCode(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('referralCodeCopied'.tr, style: GoogleFonts.poppins()),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _shareReferralCode(BuildContext context, String code) async {
    final shareText =
        '''
🎉 ${'joinMeMessage'.tr}

${'useMyCode'.tr}: $code

${'getDiscounts'.tr}

${'downloadApp'.tr}: $code
''';
    await Clipboard.setData(ClipboardData(text: shareText));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('referralMessageCopied'.tr, style: GoogleFonts.poppins()),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final referralCode = _getReferralCode();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: buildAppBar(context, "referEarn".tr),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.card_giftcard, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'referEarnRewards'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'shareCodeMessage'.tr,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.white.withValues(alpha: 0.9)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'yourReferralCode'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'code'.tr,
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                referralCode,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy, color: AppColors.primary, size: 24),
                          onPressed: () => _copyReferralCode(context, referralCode),
                          tooltip: 'copyCode'.tr,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _shareReferralCode(context, referralCode),
                          icon: const Icon(Icons.share, size: 20),
                          label: Text(
                            'share'.tr,
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _copyReferralCode(context, referralCode),
                          icon: const Icon(Icons.copy, size: 20),
                          label: Text(
                            'copy'.tr,
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary, width: 2),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'howItWorks'.tr,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStepItem(
                    stepNumber: 1,
                    title: 'shareYourCode'.tr,
                    description: 'shareCodeDescription'.tr,
                    icon: Icons.share,
                  ),
                  const SizedBox(height: 16),
                  _buildStepItem(
                    stepNumber: 2,
                    title: 'theySignUp'.tr,
                    description: 'signUpDescription'.tr,
                    icon: Icons.person_add,
                  ),
                  const SizedBox(height: 16),
                  _buildStepItem(
                    stepNumber: 3,
                    title: 'youBothEarn'.tr,
                    description: 'bothEarnDescription'.tr,
                    icon: Icons.card_giftcard,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.stars, color: AppColors.amber, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'rewards'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRewardItem(
                    title: 'forYou'.tr,
                    description: 'forYouReward'.tr,
                    icon: Icons.account_circle,
                  ),
                  const SizedBox(height: 12),
                  _buildRewardItem(
                    title: 'forYourFriend'.tr,
                    description: 'forFriendReward'.tr,
                    icon: Icons.person,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
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
                        'rewardsCreditInfo'.tr,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue[900], height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem({
    required int stepNumber,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: Center(
            child: Text(
              '$stepNumber',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600], height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRewardItem({required String title, required String description, required IconData icon}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const SizedBox(height: 2),
              Text(description, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }
}
