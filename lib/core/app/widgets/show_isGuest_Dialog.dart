// ✅ دالة عرض تنبيه تسجيل الدخول
// ignore_for_file: non_constant_identifier_names

import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:flutter/material.dart';

void show_isGuest_Dialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.lock_outline, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          Text('loginRequired'.tr, style: const TextStyle(fontSize: 18)),
        ],
      ),
      content: Text('pleaseLoginToContinue'.tr, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('cancel'.tr, style: const TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);

            push(AppRoutes.login);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('loginNow'.tr, style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
