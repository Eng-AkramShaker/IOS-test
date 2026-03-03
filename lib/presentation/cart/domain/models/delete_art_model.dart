class DeleteCart {
  final bool? success;
  final Data? data;
  final String? message;

  DeleteCart({this.success, this.data, this.message});

  factory DeleteCart.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return DeleteCart(
      success: json['success'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson(), 'message': message};
  }
}

class Data {
  final num? cartId;
  final num? itemsCount;
  final num? total;

  Data({this.cartId, this.itemsCount, this.total});

  factory Data.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Data(cartId: json['cart_id'], itemsCount: json['items_count'], total: json['total']);
  }

  Map<String, dynamic> toJson() {
    return {'cart_id': cartId, 'items_count': itemsCount, 'total': total};
  }
}
