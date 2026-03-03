import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> hasSearchText;
  final LayerLink layerLink;
  final Function(String) onChanged;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const HomeSearchBar({
    super.key,
    required this.controller,
    required this.hasSearchText,
    required this.layerLink,
    required this.onChanged,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'searchProducts'.tr,
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  border: InputBorder.none,
                ),
                onChanged: onChanged,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: hasSearchText,
              builder: (_, hasText, __) => hasText
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[400], size: 20),
                      onPressed: onClear,
                    )
                  : const SizedBox.shrink(),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.primary, size: 20),
              onPressed: onSearch,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
