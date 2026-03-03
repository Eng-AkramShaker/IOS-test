class CategoriesModel {
  final bool? success;
  final Data? data;

  CategoriesModel({this.success, this.data});

  factory CategoriesModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return CategoriesModel(
      success: json['success'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson()};
  }
}

class Data {
  final List<Categories?>? categories;
  final num? total;
  final String? type;

  Data({this.categories, this.total, this.type});

  factory Data.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Data(
      categories: json['categories'] != null
          ? List<Categories>.from(json['categories'].map((item) => Categories.fromJson(item)))
          : null,
      total: json['total'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories?.map((item) => item?.toJson()).toList(),
      'total': total,
      'type': type,
    };
  }
}

class Categories {
  final num? id;
  final String? name;
  final num? categoryId;
  final String? icon;
  final num? sequence;
  final num? productsCount;

  Categories({this.id, this.name, this.categoryId, this.icon, this.sequence, this.productsCount});

  factory Categories.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Categories(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      icon: json['icon'],
      sequence: json['sequence'],
      productsCount: json['products_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'icon': icon,
      'sequence': sequence,
      'products_count': productsCount,
    };
  }
}
