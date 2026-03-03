// ignore_for_file: deprecated_member_use

import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/constants/app_constants.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/wishlist/controllers/wishlist_provider.dart';
import 'package:buynuk/presentation/wishlist/domain/models/wishlist_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistProvider>().getWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProvider>();
    final items = wishlistProvider.wishlistModel?.data?.items ?? [];

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: buildAppBar(context, "myFavorites".tr),

        body: Column(
          children: [
            wishlistProvider.isLoading
                ? Expanded(child: Center(child: LoadingWidget()))
                : items.isEmpty
                ? _buildEmptyState()
                : _buildList(context, wishlistProvider, items),
          ],
        ),
      ),
    );
  }

  // ─── Empty State ───────────────────────────────────────────

  Widget _buildEmptyState() {
    return Expanded(
      // ✅ أضف Expanded
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'wishlistEmpty'.tr,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text('tapHeartToAdd'.tr, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  // ─── List ──────────────────────────────────────────────────

  Widget _buildList(BuildContext context, WishlistProvider wishlistProvider, List<Items?> items) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          if (item == null) return const SizedBox.shrink();
          return _buildItem(context, wishlistProvider, item);
        },
      ),
    );
  }

  // ─── Item ──────────────────────────────────────────────────

  Widget _buildItem(BuildContext context, WishlistProvider wishlistProvider, Items item) {
    return InkWell(
      onTap: () {
        // push(AppRoutes.productDetails, arguments: item)
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "${AppConstants.img}${item.image ?? ''}",
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[200],
                  child: Icon(Icons.image, color: Colors.grey[400]),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item.price ?? ''} SAR',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'inStock'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () async {
                final confirmed = await _confirmDelete(context, item.name);
                if (confirmed == true) {
                  await wishlistProvider.remove(int.tryParse(item.productId ?? '') ?? 0);
                }
              },
              icon: const Icon(Icons.delete, color: Colors.red, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Confirm Delete Dialog ─────────────────────────────────

  Future<bool?> _confirmDelete(BuildContext context, String? name) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Center(
          child: Text('myFavorites'.tr, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        ),
        content: Text(name ?? '', style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr, style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('remove'.tr, style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
