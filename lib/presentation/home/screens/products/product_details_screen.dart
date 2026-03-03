// ignore_for_file: deprecated_member_use, dead_code

import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/app/widgets/show_isGuest_Dialog.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/constants/app_constants.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/auth/controllers/auth_provider.dart';
import 'package:buynuk/presentation/cart/controllers/cart_provider.dart';
import 'package:buynuk/presentation/home/domain/models/products_model.dart';
import 'package:buynuk/presentation/payment_methods/controllers/payment_provider.dart';
import 'package:buynuk/presentation/payment_methods/screens/payment_methods_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Products product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  final ValueNotifier<bool> _isFavoriteNotifier = ValueNotifier<bool>(false);
  late TabController _tabController;
  late PageController _pageController;
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _isFavoriteNotifier.dispose();
    super.dispose();
  }

  // ─── Helpers ───────────────────────────────────────────────

  bool get _hasDiscount => widget.product.discountPercentage > 0;

  String get _imageUrl => "${AppConstants.img}${widget.product.image ?? ''}";

  //  ─── Colors ───────────────────────────────────────────────

  List<Color> get availableColors => [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.black,
    Colors.green,
    Colors.white,
  ];
  String _getColorName(Color color) {
    if (color == Colors.red) return 'أحمر';
    if (color == Colors.blue) return 'أزرق';
    if (color == Colors.yellow) return 'أصفر';
    if (color == Colors.black) return 'أسود';
    if (color == Colors.green) return 'أخضر';
    if (color == Colors.white) return 'أبيض';
    return '';
  }

  // ─── Build ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.of(context).pop(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildImageSection(), _buildInfoSection()],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 18),
          ),
        ),
      ),
      title: Text(
        'productDetails'.tr,
        style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      actions: [
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            final bool isGuest = authProvider.isGuest;

            return ValueListenableBuilder<bool>(
              valueListenable: _isFavoriteNotifier,
              builder: (_, isFavorite, __) => IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(isFavorite),
                    color: isFavorite ? Colors.red : Colors.black,
                  ),
                ),
                onPressed: () {
                  // ✅ التحقق من وضع الزائر
                  if (isGuest) {
                    show_isGuest_Dialog(context);
                    return;
                  }
                  _isFavoriteNotifier.value = !_isFavoriteNotifier.value;
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // ─── Image Section ─────────────────────────────────────────

  Widget _buildImageSection() {
    return Container(
      height: 300,
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemCount: 1,
            itemBuilder: (_, __) => ClipRRect(
              child: Image.network(
                _imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const Center(
                        child: Expanded(child: Center(child: LoadingWidget())),
                      ),
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(Icons.image_not_supported_rounded, size: 120, color: Colors.grey[400]),
                ),
              ),
            ),
          ),

          // ✅ شارة الخصم
          if (_hasDiscount)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  '${widget.product.discountPercentage.toStringAsFixed(0)}% ${'off'.tr}',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Info Section ──────────────────────────────────────────

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ اسم المنتج
          Text(
            widget.product.name ?? '',
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          const SizedBox(height: 8),

          // ✅ التقييم وعدد المراجعات
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                '${widget.product.rating ?? 0}',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 4),
              Text(
                '(${widget.product.reviewCount ?? 0} ${'review'.tr})',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ✅ السعر
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _hasDiscount
                    ? '${widget.product.discountPrice} ${widget.product.currency ?? ''}'
                    : '${widget.product.price} ${widget.product.currency ?? ''}',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: _hasDiscount ? Colors.red : Colors.black87,
                ),
              ),
              if (_hasDiscount) ...[
                const SizedBox(width: 12),
                Text(
                  '${widget.product.price} ${widget.product.currency ?? ''}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey[500],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 16),
          _buildColorSelector(), // ✅
          const SizedBox(height: 24),

          // ✅ التوصيل
          Row(
            children: [
              Icon(Icons.local_shipping, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('expressDelivery'.tr, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 24),

          // ─── Tabs ─────────────────────────────────────────
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(
                child: Text(
                  'description'.tr,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
              Tab(
                child: Text(
                  'specification'.tr,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
              Tab(
                child: Text(
                  'review'.tr,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [_buildDescriptionTab(), _buildSpecificationTab(), _buildReviewTab()],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Description Tab ───────────────────────────────────────

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name ?? '',
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Text(
            widget.product.description?.isNotEmpty == true ? widget.product.description! : 'noDescription'.tr,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], height: 1.6),
          ),
        ],
      ),
    );
  }

  // ─── Specification Tab ─────────────────────────────────────

  Widget _buildSpecificationTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpecRow('category'.tr, widget.product.categoryNames?.join(', ') ?? '-'),
          _buildSpecRow('status'.tr, widget.product.inStock ? 'available'.tr : 'outOfStock'.tr),
          _buildSpecRow('price'.tr, '${widget.product.price} ${widget.product.currency ?? ''}'),
          if (_hasDiscount) ...[
            _buildSpecRow(
              'discountPrice'.tr,
              '${widget.product.discountPrice} ${widget.product.currency ?? ''}',
            ),
            _buildSpecRow('discount'.tr, '${widget.product.discountPercentage.toStringAsFixed(0)}%'),
          ],
          _buildSpecRow('rating'.tr, '${widget.product.rating ?? 0} ⭐'),
          _buildSpecRow('review'.tr, '${widget.product.reviewCount ?? 0}'),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // ─── Review Tab ────────────────────────────────────────────

  Widget _buildReviewTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.reviews_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('noReviews'.tr, style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text('beFirstReview'.tr, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  // ─── Bottom Bar ────────────────────────────────────────────

  Widget _buildBottomBar() {
    final bool canBuy = widget.product.inStock;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        child: Consumer2<AuthProvider, CartProvider>(
          builder: (context, authProvider, cartProvider, _) {
            final bool isGuest = authProvider.isGuest;
            final bool isLoading = cartProvider.isProductLoading(widget.product.id ?? 0);

            return Row(
              children: [
                // ✅ أضف للسلة
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: (canBuy && !isLoading)
                        ? () async {
                            // ✅ التحقق من وضع الزائر
                            if (isGuest) {
                              show_isGuest_Dialog(context);
                              return;
                            }
                            await context.read<CartProvider>().addToCart(widget.product.id!);
                          }
                        : null,
                    icon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                          )
                        : Icon(Icons.shopping_bag_outlined, color: canBuy ? AppColors.primary : Colors.grey),
                    label: Text(
                      canBuy ? 'addToCart'.tr : 'outOfStock'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: canBuy ? AppColors.primary : Colors.grey,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: canBuy ? AppColors.primary : Colors.grey, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // ✅ اشتري الآن
                Expanded(
                  child: ElevatedButton(
                    onPressed: canBuy
                        ? () {
                            // ✅ التحقق من وضع الزائر
                            if (isGuest) {
                              show_isGuest_Dialog(context);
                              return;
                            }

                            final total = cartProvider.cartModel?.data?.total ?? 0;

                            context.read<PaymentProvider>().init(total.toDouble());

                            showPaymentMethodsSheet(context: context, amount: total.toDouble());
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canBuy ? AppColors.primary : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      canBuy ? 'buyNow'.tr : 'outOfStock'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildColorSelector() {
    final colors = availableColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'color'.tr,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(width: 8),
            if (_selectedColor != null)
              Text(
                _getColorName(_selectedColor!),
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: colors.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey[300]!,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2)]
                      : [],
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: color == Colors.white || color == Colors.yellow ? Colors.black : Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
