class ProductsModel {
  final bool? success;
  final Data? data;

  ProductsModel({this.success, this.data});

  factory ProductsModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ProductsModel(
      success: json['success'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson()};
  }
}

class Data {
  final List<Products?>? products;
  final num? total;
  final num? limit;
  final num? offset;

  Data({this.products, this.total, this.limit, this.offset});

  factory Data.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Data(
      products: json['products'] != null
          ? List<Products>.from(json['products'].map((item) => Products.fromJson(item)))
          : null,
      total: json['total'],
      limit: json['limit'],
      offset: json['offset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products?.map((item) => item?.toJson()).toList(),
      'total': total,
      'limit': limit,
      'offset': offset,
    };
  }
}

class Products {
  final int? id;
  final String? name;
  final String? description;
  final num? price;
  final num? discountPrice;
  final String? currency;
  final String? image;
  final List<num?>? categoryIds;
  final List<String?>? categoryNames;
  final bool? available;
  final num? rating;
  final num? reviewCount;

  final num? listPrice;
  final num? discountPercent;
  final String? discountLabel;

  Products({
    this.id,
    this.name,
    this.description,
    this.price,
    this.discountPrice,
    this.currency,
    this.image,
    this.categoryIds,
    this.categoryNames,
    this.available,
    this.rating,
    this.reviewCount,
    this.listPrice,
    this.discountPercent,
    this.discountLabel,
  });

  factory Products.fromJson(Map<String, dynamic>? json) {
    json ??= {};

    return Products(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      discountPrice: json['discount_price'],
      currency: json['currency'],
      image: json['image'],
      categoryIds: json['category_ids'] != null
          ? List<num>.from(json['category_ids'].map((e) => e as num))
          : null,
      categoryNames: json['category_names'] != null ? List<String>.from(json['category_names']) : null,
      available: json['available'],
      rating: json['rating'],
      reviewCount: json['review_count'],
      listPrice: json['list_price'],
      discountPercent: json['discount_percent'],
      discountLabel: json['discount_label'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'discount_price': discountPrice,
    'currency': currency,
    'image': image,
    'category_ids': categoryIds,
    'category_names': categoryNames,
    'available': available,
    'rating': rating,
    'review_count': reviewCount,
    'list_price': listPrice,
    'discount_percent': discountPercent,
    'discount_label': discountLabel,
  };

  double get discountPercentage {
    if (discountPercent != null) {
      return discountPercent!.toDouble();
    }

    final p = price?.toDouble() ?? 0;
    final d = discountPrice?.toDouble() ?? 0;

    if (d > 0 && p > d) {
      return ((p - d) / p) * 100;
    }
    return 0.0;
  }

  bool get inStock => available ?? false;

  int get stock => (available ?? false) ? 1 : 0;
}
