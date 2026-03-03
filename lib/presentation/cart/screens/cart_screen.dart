// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/constants/app_constants.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/cart/controllers/cart_provider.dart';
import 'package:buynuk/presentation/cart/domain/models/cart_model.dart';
import 'package:buynuk/presentation/payment_methods/controllers/payment_provider.dart';
import 'package:buynuk/presentation/payment_methods/screens/payment_methods_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _itemsController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _itemsFade;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _itemsController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _headerFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOut));
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOut));
    _itemsFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _itemsController, curve: Curves.easeOut));

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _itemsController.forward();
    });

    // =====================================================================================

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cartProvider = context.read<CartProvider>();
      final paymentProvider = context.read<PaymentProvider>();

      await cartProvider.getCart();

      final total = cartProvider.cartModel?.data?.total ?? 0;

      if (total > 0) {
        paymentProvider.init(total.toDouble());
      }
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _itemsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: buildAppBar(context, "cart".tr),

        body: SafeArea(
          child: FadeTransition(
            opacity: _itemsFade,
            child: Consumer<CartProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) return _buildLoading();
                if (provider.errorMessage != null) return _buildError(provider.errorMessage!);
                final items = provider.cartModel?.data?.items;
                if (items == null || items.isEmpty) return _buildEmptyCart();
                return _buildContent(provider);
              },
            ),
          ),
        ),
        bottomNavigationBar: Consumer<CartProvider>(
          builder: (context, provider, _) {
            final hasItems = provider.cartModel?.data?.items?.isNotEmpty == true;
            if (!hasItems) return const SizedBox.shrink();
            return _buildBottomBar(context, provider);
          },
        ),
      ),
    );
  }

  // ── Content ──────────────────────────────────
  Widget _buildContent(CartProvider provider) {
    final data = provider.cartModel!.data!;
    final items = data.items!;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 8),
              Text(
                'orderItems'.tr,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ...List.generate(items.length, (index) {
            final item = items[index];
            if (item == null) return const SizedBox.shrink();
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 350 + (index * 120)),
              curve: Curves.easeOut,
              builder: (_, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(offset: Offset(0, 24 * (1 - value)), child: child),
              ),
              child: _buildCartItem(item),
            );
          }),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ── Cart Item ──────────────────────────────────
  Widget _buildCartItem(Items item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: item.image != null
                    ? Image.network(
                        "${AppConstants.img}${item.image ?? ''}",
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
            ),
            const SizedBox(width: 14),

            // ── Info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Delete button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.productName ?? '',
                          style: GoogleFonts.cairo(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        '\$${item.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: GoogleFonts.cairo(color: AppColors.primary, fontSize: 18),
                      ),
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ── Minus ──
                            _qtyButton(
                              icon: Icons.remove_rounded,
                              onTap: () => context.read<CartProvider>().deleteCart(
                                item.productId ?? 0,
                                showLoadingPage: true,
                              ),
                            ),

                            // ── Count ──
                            Container(
                              width: 36,
                              alignment: Alignment.center,
                              child: Text(
                                '${item.quantity?.toInt() ?? 1}',
                                style: GoogleFonts.dmSans(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            // ── Plus ──
                            _qtyButton(
                              icon: Icons.add_rounded,
                              onTap: () => context.read<CartProvider>().addToCart(
                                item.productId ?? 0,
                                showLoadingPage: true,
                              ),
                              isPrimary: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ── Quantity Controls ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Subtotal
                      if (item.subtotal != null)
                        Text(
                          '\$${item.subtotal!.toStringAsFixed(2)} : ${'total'.tr} ',
                          style: GoogleFonts.cairo(color: AppColors.textSecondary, fontSize: 11),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Quantity Button ──────────────────────────
  Widget _qtyButton({required IconData icon, required VoidCallback onTap, bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(isPrimary ? 10 : 0),
        ),
        child: Icon(icon, size: 16, color: isPrimary ? Colors.white : AppColors.textPrimary),
      ),
    );
  }

  // ── Bottom Bar ──────────────────────────────────
  Widget _buildBottomBar(BuildContext context, CartProvider provider) {
    final total = provider.cartModel?.data?.total ?? 0;
    final currency = provider.cartModel?.data?.currency ?? '\$';

    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      margin: EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          final total = provider.cartModel?.data?.total ?? 0;

          context.read<PaymentProvider>().init(total.toDouble());

          showPaymentMethodsSheet(context: context, amount: total.toDouble());
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'proceedToCheckout'.tr,
                style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$currency  ${total.toStringAsFixed(2)}',
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── States ──────────────────────────────────────
  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: LoadingWidget()),
          const SizedBox(height: 16),
          Text('loadingCart'.tr, style: GoogleFonts.cairo(color: AppColors.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), shape: BoxShape.circle),
              child: const Icon(Icons.wifi_off_rounded, color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              'somethingWentWrong'.tr,
              style: GoogleFonts.cairo(color: AppColors.textPrimary, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.cairo(color: AppColors.textSecondary, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => context.read<CartProvider>().getCart(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14)),
                child: Text(
                  'tryAgain'.tr,
                  style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.07), shape: BoxShape.circle),
            child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 46),
          ),
          const SizedBox(height: 20),
          Text('cartEmpty'.tr, style: GoogleFonts.cairo(color: AppColors.textPrimary, fontSize: 22)),
          const SizedBox(height: 8),
          Text('addItemsToStart'.tr, style: GoogleFonts.cairo(color: AppColors.textSecondary, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.backgroundLight,
      child: const Icon(Icons.image_outlined, color: AppColors.textSecondary, size: 28),
    );
  }
}
