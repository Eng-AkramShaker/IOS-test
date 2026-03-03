// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/home/controllers/home_provider.dart';
import 'package:buynuk/presentation/home/domain/models/banners_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeBanner extends StatelessWidget {
  final HomeProvider homeProvider;
  final ValueNotifier<int> bannerIndexNotifier;

  const HomeBanner({super.key, required this.homeProvider, required this.bannerIndexNotifier});

  @override
  Widget build(BuildContext context) {
    final banners = homeProvider.bannersModel?.data?.banners;
    if (banners == null || banners.isEmpty) return const SizedBox();

    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: banners.length,
            onPageChanged: (i) => bannerIndexNotifier.value = i,
            itemBuilder: (_, i) {
              final banner = banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: _BannerCard(banner: banner),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<int>(
          valueListenable: bannerIndexNotifier,
          builder: (_, current, __) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (i) {
              final isActive = current == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isActive ? 30 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isActive ? AppColors.primary : Colors.grey[300],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final Banners? banner;

  const _BannerCard({required this.banner});

  void _onTap(BuildContext context) async {
    final productId = banner?.productId;

    debugPrint("\x1B[32m     productId: $productId     \x1B[0m");

    if (productId == null) {
      debugPrint('No productId found in link: ${banner?.link}');
      return;
    }

    final homeProvider = context.read<HomeProvider>();
    await homeProvider.getBannerProductById(productId);

    final product = homeProvider.bannerProduct;

    if (product != null) {
      push(AppRoutes.productDetails, arguments: product);
    } else {
      debugPrint('Product not found for id: $productId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => _onTap(context),
          child: Stack(
            children: [
              child!,
              if (provider.isLoadingBannerProduct)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(child: LoadingWidget()),
                  ),
                ),
            ],
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── صورة البانر ──
            Image.network(
              banner?.imageUrl ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: Icon(Icons.image, color: Colors.grey[400], size: 60),
              ),
              loadingBuilder: (_, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[100],
                  child: const Center(child: LoadingWidget()),
                );
              },
            ),

            // ── Gradient Overlay ──
            if (banner?.title != null || banner?.description != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.65), Colors.transparent],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (banner?.title != null && banner!.title!.isNotEmpty)
                        Text(
                          banner!.title!,
                          style: TextStyle(
                            color: banner?.textColor != null ? _hexToColor(banner!.textColor!) : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (banner?.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          banner!.description!,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (banner?.linkText != null) ...[
                        const SizedBox(height: 6),
                        // ✅ زر تسوق الآن
                        GestureDetector(
                          onTap: () => _onTap(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "shopNow".tr,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return Colors.white;
    }
  }
}
