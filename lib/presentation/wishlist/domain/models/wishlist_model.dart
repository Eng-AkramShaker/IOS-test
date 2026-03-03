class WishlistModel {
  final bool? success;
  final Data? data;

  WishlistModel({this.success, this.data});

  factory WishlistModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return WishlistModel(
      success: [int, double, num].contains(json['success'].runtimeType)
          ? json['success'].toString()
          : json['success'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson()};
  }
}

class Data {
  final List<Items?>? items;
  final String? total;

  Data({this.items, this.total});

  factory Data.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Data(
      items: json['items'] != null
          ? List<Items>.from(json['items'].map((item) => Items.fromJson(item)))
          : null,
      total: [int, double, num].contains(json['total'].runtimeType)
          ? json['total'].toString()
          : json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'items': items?.map((item) => item?.toJson()).toList(), 'total': total};
  }
}

class Items {
  final String? id;
  final String? productId;
  final String? productVariantId;
  final String? name;
  final String? price;
  final String? image;
  final String? addedDate;

  Items({
    this.id,
    this.productId,
    this.productVariantId,
    this.name,
    this.price,
    this.image,
    this.addedDate,
  });

  factory Items.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Items(
      id: [int, double, num].contains(json['id'].runtimeType) ? json['id'].toString() : json['id'],
      productId: [int, double, num].contains(json['product_id'].runtimeType)
          ? json['product_id'].toString()
          : json['product_id'],
      productVariantId: [int, double, num].contains(json['product_variant_id'].runtimeType)
          ? json['product_variant_id'].toString()
          : json['product_variant_id'],
      name: [int, double, num].contains(json['name'].runtimeType)
          ? json['name'].toString()
          : json['name'],
      price: [int, double, num].contains(json['price'].runtimeType)
          ? json['price'].toString()
          : json['price'],
      image: [int, double, num].contains(json['image'].runtimeType)
          ? json['image'].toString()
          : json['image'],
      addedDate: [int, double, num].contains(json['added_date'].runtimeType)
          ? json['added_date'].toString()
          : json['added_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_variant_id': productVariantId,
      'name': name,
      'price': price,
      'image': image,
      'added_date': addedDate,
    };
  }
}
