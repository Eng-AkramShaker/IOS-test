import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/home/controllers/home_provider.dart';
import 'package:buynuk/presentation/home/screens/products/all_products_screen.dart';
import 'package:buynuk/presentation/home/widget/product_card__Widget.dart';
import 'package:buynuk/presentation/wishlist/controllers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeBestSelling extends StatelessWidget {
  final HomeProvider homeProvider;

  const HomeBestSelling({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    final products = homeProvider.bestSellingModel?.data?.products ?? [];
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'bestSellingProducts'.tr,
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black54),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AllProductsScreen())),
                child: Text(
                  'seeAll'.tr,
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index]!;

              return SizedBox(
                width: 230,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ProductCard_Widget(
                    product: product,
                    isFavorite: false,
                    onTap: () => push(AppRoutes.productDetails, arguments: product),
                    onFavoriteTap: () => context.read<WishlistProvider>().addWishlist(product.id!),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
