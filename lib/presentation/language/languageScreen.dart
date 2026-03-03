// ignore_for_file: use_build_context_synchronously

import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/language/language_provider.dart';

class LanguageScreen extends StatefulWidget {
  bool fromProfile;

  LanguageScreen({super.key, required this.fromProfile});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = 'en';

  final languages = const [
    {"name": "English", "code": "en", "flag": "🇺🇸"},

    {"name": "العربية", "code": "ar", "flag": "🇸🇦"},
  ];
  @override
  void initState() {
    super.initState();
    intS();
  }

  void intS() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: buildAppBar(context, "language".tr, showBottom: true),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text("Choose your language", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

              const Text("اختر لغتك", style: TextStyle(color: Colors.grey)),

              /// Language Grid
              Expanded(
                child: Center(
                  child: GridView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: languages.length,

                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,

                      crossAxisSpacing: 15,

                      mainAxisSpacing: 15,
                    ),

                    itemBuilder: (context, index) {
                      final lang = languages[index];

                      final isSelected = selectedLanguage == lang["code"];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedLanguage = lang["code"]!;
                          });
                        },

                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,

                            borderRadius: BorderRadius.circular(16),

                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,

                              width: 2,
                            ),
                          ),

                          child: Stack(
                            children: [
                              if (isSelected)
                                const Positioned(
                                  top: 8,
                                  left: 8,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: AppColors.primary,
                                    child: Icon(Icons.check, size: 14, color: Colors.white),
                                  ),
                                ),

                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    Text(lang["flag"]!, style: const TextStyle(fontSize: 40)),

                                    const SizedBox(height: 10),

                                    Text(lang["name"]!),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              /// NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    final provider = context.read<LanguageProvider>();

                    await provider.changeLanguage(selectedLanguage);

                    if (widget.fromProfile) {
                      Navigator.pop(context, true);
                    } else {
                      pushRemoveUntil(AppRoutes.login);
                    }
                  },

                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),

                  child: Text("next".tr, style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
