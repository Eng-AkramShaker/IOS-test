// ignore_for_file: deprecated_member_use

import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    context.watch<LanguageProvider>();

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 0 — New Arrivals
                _navItem(
                  icon: Icons.fiber_new_outlined,
                  filledIcon: Icons.fiber_new,
                  label: 'newArrival'.tr,
                  index: 0,
                ),

                // 1 — Orders
                _navItem(
                  icon: Icons.receipt_long_outlined,
                  filledIcon: Icons.receipt_long,
                  label: 'myOrders'.tr,
                  index: 1,
                ),

                // 2 — Wishlist
                _navItem(
                  icon: Icons.favorite_border,
                  filledIcon: Icons.favorite,
                  label: 'favorites'.tr,
                  index: 2,
                ),

                // فراغ للزر الأوسط
                const SizedBox(width: 56),

                // 4 — Flash Sales
                _navItem(icon: Icons.bolt_outlined, filledIcon: Icons.bolt, label: 'flashsale'.tr, index: 4),

                // 5 — Cart
                _navItem(
                  icon: Icons.shopping_cart_outlined,
                  filledIcon: Icons.shopping_cart,
                  label: 'cart'.tr,
                  index: 5,
                ),

                // 6 — Profile
                _navItem(icon: Icons.person_outline, filledIcon: Icons.person, label: 'profile'.tr, index: 6),
              ],
            ),
          ),

          // زر الهوم الأوسط (index 3)
          Positioned(left: MediaQuery.of(context).size.width / 2 - 28, top: -28, child: _centerButton()),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required IconData filledIcon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? filledIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected ? AppColors.primary : Colors.grey[400],
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: isSelected ? AppColors.primary : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _centerButton() {
    final isSelected = currentIndex == 3;

    return GestureDetector(
      onTap: () => onTap(3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.85),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.home_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}
