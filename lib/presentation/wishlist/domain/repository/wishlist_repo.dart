// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:buynuk/core/services/api_service.dart';
import 'package:buynuk/presentation/wishlist/domain/models/add_wishlist_model';
import 'package:buynuk/presentation/wishlist/domain/models/wishlist_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

class WishlistRepository {
  final ApiClient apiClient;

  WishlistRepository({required this.apiClient});

  // -----------------------------------------------------------------------
  ///  getWishlist
  // -----------------------------------------------------------------------

  Future<WishlistModel> getWishlist() async {
    final http.Response response = await apiClient.getData(AppConstants.wishlistUri);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return WishlistModel.fromJson(json);
  }

  // -----------------------------------------------------------------------
  ///  addToWishlist
  // -----------------------------------------------------------------------

  Future<AddwishlistModel> addToWishlist(int productId) async {
    final http.Response response = await apiClient.postData(AppConstants.wishlistAddUri, {
      "product_id": productId,
    });

    final Map<String, dynamic> json = jsonDecode(response.body);
    return AddwishlistModel.fromJson(json);
  }

  // -----------------------------------------------------------------------
  ///  remove
  // -----------------------------------------------------------------------
  Future<http.Response> remove(int productId) async {
    return await apiClient.postData(AppConstants.wishlistRemoveUri, {"product_id": productId});
  }
}
