// add_to_cart_model.dart
class AddToCartModel {
  final bool? success;
  final AddToCartData? data;
  final String? message;

  AddToCartModel({this.success, this.data, this.message});

  factory AddToCartModel.fromJson(Map<String, dynamic> json) => AddToCartModel(
    success: json['success'],
    data: json['data'] != null ? AddToCartData.fromJson(json['data']) : null,
    message: json['message'],
  );
}

class AddToCartData {
  final int? cartId;
  final int? productId;
  final double? quantity;

  AddToCartData({this.cartId, this.productId, this.quantity});

  factory AddToCartData.fromJson(Map<String, dynamic> json) => AddToCartData(
    cartId: json['cart_id'],
    productId: json['product_id'],
    quantity: (json['quantity'] as num?)?.toDouble(),
  );
}
