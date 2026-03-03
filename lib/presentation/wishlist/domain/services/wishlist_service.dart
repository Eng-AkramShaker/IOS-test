// ignore_for_file: depend_on_referenced_packages

import 'package:buynuk/presentation/wishlist/domain/models/add_wishlist_model';
import 'package:buynuk/presentation/wishlist/domain/models/wishlist_model.dart';
import 'package:buynuk/presentation/wishlist/domain/repository/wishlist_repo.dart';
import 'package:http/http.dart' as http;

class WishlistService {
  final WishlistRepository wishlistRepository;

  WishlistService({required this.wishlistRepository});

  // -----------------------------------------------------------------------
  ///  getWishlist
  // -----------------------------------------------------------------------

  Future<WishlistModel> getWishlist() async {
    return await wishlistRepository.getWishlist();
  }

  // -----------------------------------------------------------------------
  ///  addToWishlist
  // -----------------------------------------------------------------------

  Future<AddwishlistModel> addToWishlist(int productId) async {
    return await wishlistRepository.addToWishlist(productId);
  }

  // -----------------------------------------------------------------------
  ///  remove
  // -----------------------------------------------------------------------

  Future<http.Response> remove(int productId) async {
    return await wishlistRepository.remove(productId);
  }
}
