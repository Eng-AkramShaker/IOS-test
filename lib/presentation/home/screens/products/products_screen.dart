import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/home/controllers/home_provider.dart';
import 'package:buynuk/presentation/home/widget/product_card__Widget.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/wishlist/controllers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  final String categoryId;

  const ProductsScreen({super.key, required this.categoryId});

  @override
  State<ProductsScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<ProductsScreen> {
  final Map<String, ValueNotifier<bool>> _favoriteNotifiers = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    for (var notifier in _favoriteNotifiers.values) {
      notifier.dispose();
    }
    _favoriteNotifiers.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("\x1B[32m     ${widget.categoryId}     \x1B[0m");
      context.read<HomeProvider>().getProductsId(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    final allProducts = homeProvider.productsIdModel?.data?.products ?? [];
    final filteredProducts = _searchController.text.isEmpty
        ? allProducts
        : allProducts.where((p) {
            final query = _searchController.text.toLowerCase();
            return (p?.name ?? '').toLowerCase().contains(query) ||
                (p?.description ?? '').toLowerCase().contains(query);
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => pop(),
        ),
        title: Text(
          'products'.tr,
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: homeProvider.isLoading_productsId
          ? const Center(child: LoadingWidget())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // ─── Search Bar ───────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(Icons.search, color: Colors.grey[400]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(hintText: 'search'.tr, border: InputBorder.none),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.mic, color: Colors.grey[400]),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),

                  // ─── Empty State ──────────────────────────────────
                  if (filteredProducts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Column(
                        children: [
                          Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text('no_products'.tr, style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                        ],
                      ),
                    )
                  // ─── Grid ─────────────────────────────────────────
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index]!;

                          return ProductCard_Widget(
                            product: product,
                            isFavorite: false,
                            onTap: () {
                              push(AppRoutes.productDetails, arguments: product);
                            },
                            onFavoriteTap: () => context.read<WishlistProvider>().addWishlist(product.id!),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
