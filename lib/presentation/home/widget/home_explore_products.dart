import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/home/controllers/home_provider.dart';
import 'package:buynuk/presentation/home/widget/product_card__Widget.dart';
import 'package:buynuk/presentation/wishlist/controllers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeExploreProducts extends StatelessWidget {
  final HomeProvider homeProvider;

  const HomeExploreProducts({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    final products = homeProvider.productsModel?.data?.products ?? [];
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'exploreOurProducts'.tr,
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index]!;

              return ProductCard_Widget(
                product: product,
                isFavorite: false,
                onTap: () => push(AppRoutes.productDetails, arguments: product),
                onFavoriteTap: () => context.read<WishlistProvider>().addWishlist(product.id!),
              );
            },
          ),
        ),
      ],
    );
  }
}
