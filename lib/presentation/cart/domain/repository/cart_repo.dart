// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:buynuk/core/services/api_service.dart';
import 'package:buynuk/presentation/cart/domain/models/add_to_cart_model.dart';
import 'package:buynuk/presentation/cart/domain/models/cart_model.dart';
import 'package:buynuk/presentation/cart/domain/models/delete_art_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

class CartRepository {
  final ApiClient apiClient;

  CartRepository({required this.apiClient});

  // -----------------------------------------------------------------------
  /// Cart
  // -----------------------------------------------------------------------

  Future<CartModel> getCart() async {
    final http.Response response = await apiClient.getData(AppConstants.cartUri);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return CartModel.fromJson(json);
  }

  // -----------------------------------------------------------------------
  /// add
  // -----------------------------------------------------------------------

  Future<AddToCartModel> addToCart(num productId) async {
    final http.Response response = await apiClient.postData(AppConstants.addToCartUri, {
      'product_id': productId,
    });

    final Map<String, dynamic> json = jsonDecode(response.body);
    return AddToCartModel.fromJson(json);
  }

  // -----------------------------------------------------------------------
  /// delete
  // -----------------------------------------------------------------------

  Future<DeleteCart> deleteCart(num productId) async {
    final http.Response response = await apiClient.deleteData(
      "${AppConstants.cartDeleteUri}?product_id=$productId",
    );

    final Map<String, dynamic> json = jsonDecode(response.body);
    return DeleteCart.fromJson(json);
  }
}
