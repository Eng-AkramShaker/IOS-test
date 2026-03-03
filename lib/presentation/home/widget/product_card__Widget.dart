// ignore_for_file: deprecated_member_use, camel_case_types

import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/app/widgets/show_isGuest_Dialog.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/constants/app_constants.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/auth/controllers/auth_provider.dart';
import 'package:buynuk/presentation/cart/controllers/cart_provider.dart';
import 'package:buynuk/presentation/home/domain/models/products_model.dart';
import 'package:buynuk/presentation/home/widget/animatedFavorite_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCard_Widget extends StatelessWidget {
  final Products product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback? onTap;

  const ProductCard_Widget({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = product.discountPercentage > 0;
    final bool isOutOfStock = product.stock <= 0;

    return Consumer2<CartProvider, AuthProvider>(
      builder: (context, cartProvider, authProvider, _) {
        final bool isLoading = cartProvider.isProductLoading(product.id!);
        final bool isGuest = authProvider.isGuest; // ✅

        return GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.network("${AppConstants.img}${product.image!}", fit: BoxFit.cover),
                      ),
                    ),

                    if (hasDiscount)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "${product.discountPercentage.toStringAsFixed(0)}% OFF",
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: AnimatedFavoriteButton(
                        isFavorite: isFavorite,
                        onTap: isGuest
                            ? () =>
                                  show_isGuest_Dialog(context) // ✅ إذا زائر، اعرض تنبيه
                            : onFavoriteTap,
                      ),
                    ),
                  ],
                ),

                ///
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? "",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      /// السعر
                      Text(
                        hasDiscount ? "${product.discountPrice}" : "${product.price}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                      ),

                      const SizedBox(height: 10),

                      /// زر الإضافة
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: ElevatedButton(
                          onPressed: (isOutOfStock || isLoading)
                              ? null
                              : () async {
                                  // ✅ التحقق من وضع الزائر
                                  if (isGuest) {
                                    show_isGuest_Dialog(context);
                                    return;
                                  }
                                  await context.read<CartProvider>().addToCart(product.id!);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isOutOfStock ? Colors.grey[300] : AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: isLoading
                              ? const SizedBox(height: 18, width: 18, child: LoadingWidget())
                              : Text(
                                  isOutOfStock ? "outOfStock".tr : "addToCart".tr,
                                  style: const TextStyle(fontSize: 11, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
