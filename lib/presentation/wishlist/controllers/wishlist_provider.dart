// ignore_for_file: non_constant_identifier_names

import 'package:buynuk/core/app/widgets/showSnackBar.dart';
import 'package:buynuk/core/services/language/language_service.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/wishlist/domain/models/add_wishlist_model';
import 'package:buynuk/presentation/wishlist/domain/models/wishlist_model.dart';
import 'package:buynuk/presentation/wishlist/domain/services/wishlist_service.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  WishlistService wishlistService;

  WishlistProvider({required this.wishlistService});

  // -----------------------------------------------------------------------
  /// State
  // -----------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  WishlistModel? _wishlistModel;
  WishlistModel? get wishlistModel => _wishlistModel;

  // -----------------------------------------------------------------------
  ///   Get
  // -----------------------------------------------------------------------

  Future<void> getWishlist() async {
    _isLoading = true;
    _errorMessage = null;
    _wishlistModel = null;
    _notify();

    try {
      _wishlistModel = await wishlistService.getWishlist();
      _notify();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      _notify();
    }
  }
  // -----------------------------------------------------------------------
  ///  add
  // -----------------------------------------------------------------------

  Future<bool> addWishlist(int productId) async {
    _isLoading = true;
    _notify();

    try {
      AddwishlistModel result = await wishlistService.addToWishlist(productId);
      if (result.success == true) {
        ShowSnackBar.success('addedToFavorites'.tr);
        await getWishlist();
        return true;
      }
      return false;
    } catch (e) {
      ShowSnackBar.error('failedToAddFavorites'.tr);
      debugPrint('Add to cart error: $e');
      return false;
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  // -----------------------------------------------------------------------
  ///   Remove
  // -----------------------------------------------------------------------

  Future<bool> remove(int productId) async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      await wishlistService.remove(productId);
      ShowSnackBar.success('removedFromFavorites'.tr);

      await getWishlist();
      return true;
    } catch (e) {
      ShowSnackBar.error('failedToRemoveFavorites'.tr);

      _errorMessage = e.toString();
      debugPrint('Error removing from wishlist: $e');
      return false;
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  //  التحقق قبل الإشعار -------------------------------------------

  bool _disposed = false;
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
