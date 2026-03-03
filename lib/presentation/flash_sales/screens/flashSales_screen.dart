// ignore_for_file: deprecated_member_use

import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/flash_sales/controllers/flashSales_provider.dart';
import 'package:buynuk/presentation/home/domain/models/products_model.dart';
import 'package:buynuk/presentation/home/widget/product_card__Widget.dart';
import 'package:buynuk/presentation/wishlist/controllers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FlashSalesScreen extends StatefulWidget {
  const FlashSalesScreen({super.key});

  @override
  State<FlashSalesScreen> createState() => _FlashSalesScreenState();
}

class _FlashSalesScreenState extends State<FlashSalesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<FlashSalesProvider>().getFlashSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        appBar: buildAppBar(context, "flashsale".tr),

        body: SafeArea(
          child: Consumer<FlashSalesProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: LoadingWidget());
              }

              if (provider.flashSalesModel?.data?.products?.isEmpty ?? true) {
                return _buildEmptyState();
              }

              return _buildGrid(provider);
            },
          ),
        ),
      ),
    );
  }

  // ─────────────── Grid   ───────────────

  Widget _buildGrid(FlashSalesProvider provider) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => provider.getFlashSales(),
      child: MasonryGridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: provider.flashSalesModel?.data?.products?.length ?? 0,
        itemBuilder: (context, index) {
          Products product = provider.flashSalesModel!.data!.products![index];

          return ProductCard_Widget(
            product: product,
            isFavorite: false,
            onTap: () {
              push(AppRoutes.productDetails, arguments: product);
            },
            onFavoriteTap: () {
              if (product.id != null) {
                context.read<WishlistProvider>().addWishlist(product.id!);
              }
            },
          );
        },
      ),
    );
  }

  // ─────────────── Empty State ───────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bolt, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'noActiveFlashSale'.tr,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text('checkBackSoon'.tr, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }
}
