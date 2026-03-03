// ignore_for_file: non_constant_identifier_names

import 'package:buynuk/core/app/widgets/showSnackBar.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/cart/domain/models/add_to_cart_model.dart';
import 'package:buynuk/presentation/cart/domain/models/cart_model.dart';
import 'package:buynuk/presentation/cart/domain/models/delete_art_model.dart';
import 'package:buynuk/presentation/cart/domain/services/cart_service.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final CartService cartService;

  CartProvider({required this.cartService});

  // -----------------------------------------------------------------------
  /// General State
  // -----------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  CartModel? _cartModel;
  CartModel? get cartModel => _cartModel;

  int? _loadingProductId;

  bool isProductLoading(int productId) => _loadingProductId == productId;

  // -----------------------------------------------------------------------
  /// Internal Helpers
  // -----------------------------------------------------------------------

  bool _disposed = false;

  void _setLoading(bool value) {
    _isLoading = value;
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  // -----------------------------------------------------------------------
  /// Get Cart
  // -----------------------------------------------------------------------

  Future<void> getCart({bool showLoading = true}) async {
    if (showLoading) _setLoading(true);

    _errorMessage = null;

    try {
      _cartModel = await cartService.getCart();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Get cart error: $e');
    } finally {
      if (showLoading) _setLoading(false);
    }
  }

  // -----------------------------------------------------------------------
  /// Add To Cart (Loading خاص بالعنصر فقط)
  // -----------------------------------------------------------------------

  Future<bool> addToCart(int productId, {bool showLoadingPage = false}) async {
    _loadingProductId = productId;
    _isLoading = true;
    _notify();

    try {
      AddToCartModel result = await cartService.addToCart(productId);

      if (result.success == true && showLoadingPage == false) {
        ShowSnackBar.success('addedToCart'.tr);

        await getCart(showLoading: false);

        return true;
      } else if (result.success == true && showLoadingPage == true) {
        ShowSnackBar.success('added'.tr);
        await getCart(showLoading: false);
        return true;
      }

      ShowSnackBar.error('failedToAdd'.tr);
      return false;
    } catch (e) {
      ShowSnackBar.error('failedToAdd'.tr);
      debugPrint('Add to cart error: $e');
      return false;
    } finally {
      _loadingProductId = null;
      _isLoading = false;
      _notify();
    }
  }

  // -----------------------------------------------------------------------
  /// Delete From Cart (Loading عام)
  // -----------------------------------------------------------------------

  Future<bool> deleteCart(num productId, {bool showLoadingPage = false}) async {
    _isLoading = true;
    _notify();
    _setLoading(true);

    try {
      DeleteCart result = await cartService.deleteCart(productId);

      if (result.success == true && showLoadingPage == false) {
        ShowSnackBar.success('removedFromCart'.tr);

        await getCart(showLoading: false);

        return true;
      } else if (result.success == true && showLoadingPage == true) {
        ShowSnackBar.success('removed'.tr);
        await getCart(showLoading: false);
        return true;
      }

      return false;
    } catch (e) {
      ShowSnackBar.error('failedToRemove'.tr);
      debugPrint('Delete cart error: $e');
      return false;
    } finally {
      _setLoading(false);

      _isLoading = false;
      _notify();
    }
  }
}
