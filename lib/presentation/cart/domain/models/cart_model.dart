class CartModel {
  final bool? success;
  final Data? data;

  CartModel({this.success, this.data});

  factory CartModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return CartModel(
      success: json['success'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson()};
  }
}

class Data {
  final num? cartId;
  final List<Items?>? items;
  final num? total;
  final num? subtotal;
  final num? tax;
  final String? currency;

  Data({this.cartId, this.items, this.total, this.subtotal, this.tax, this.currency});

  factory Data.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Data(
      cartId: json['cart_id'],
      items: json['items'] != null
          ? List<Items>.from(json['items'].map((item) => Items.fromJson(item)))
          : null,
      total: json['total'],
      subtotal: json['subtotal'],
      tax: json['tax'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'items': items?.map((item) => item?.toJson()).toList(),
      'total': total,
      'subtotal': subtotal,
      'tax': tax,
      'currency': currency,
    };
  }
}

class Items {
  final num? id;
  final int? productId;
  final String? productName;
  final num? quantity;
  final num? price;
  final num? subtotal;
  final String? image;

  Items({
    this.id,
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.subtotal,
    this.image,
  });

  factory Items.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Items(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'],
      subtotal: json['subtotal'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'subtotal': subtotal,
      'image': image,
    };
  }
}
