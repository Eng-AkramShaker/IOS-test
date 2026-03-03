class BannersModel {
  final bool? success;
  final BannersData? data;
  final String? message;

  BannersModel({this.success, this.data, this.message});

  factory BannersModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return BannersModel(
      success: json['success'],
      data: json['data'] != null ? BannersData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() => {'success': success, 'data': data?.toJson(), 'message': message};
}

class BannersData {
  final List<Banners?>? banners;

  BannersData({this.banners});

  factory BannersData.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return BannersData(
      banners: json['banners'] != null
          ? List<Banners>.from(json['banners'].map((item) => Banners.fromJson(item)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {'banners': banners?.map((item) => item?.toJson()).toList()};
}

class Banners {
  final num? id;
  final String? name;
  final String? title;
  final String? description;
  final String? imageUrl;
  final dynamic brandLogoUrl;
  final String? link;
  final String? linkText;
  final String? position;
  final num? sequence;
  final bool? active;
  final String? textColor;
  final dynamic productPrice;
  final int? productId;

  Banners({
    this.id,
    this.name,
    this.title,
    this.description,
    this.imageUrl,
    this.brandLogoUrl,
    this.link,
    this.linkText,
    this.position,
    this.sequence,
    this.active,
    this.textColor,
    this.productPrice,
    this.productId,
  });

  factory Banners.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    final link = json['link'] as String?;
    return Banners(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      brandLogoUrl: json['brand_logo_url'],
      link: link,
      linkText: json['link_text'],
      position: json['position'],
      sequence: json['sequence'],
      active: json['active'],
      textColor: json['text_color'],
      productPrice: json['product_price'],
      productId: _extractProductId(link), // ✅ يستخرج تلقائياً
    );
  }

  static int? _extractProductId(String? link) {
    if (link == null || link.isEmpty) return null;

    final uri = Uri.tryParse(link);
    if (uri == null) return null;

    final segments = uri.pathSegments;

    // ✅ /product-details-custom/10
    final index = segments.indexOf('product-details-custom');
    if (index != -1 && index + 1 < segments.length) {
      return int.tryParse(segments[index + 1]);
    }

    // /product/10
    final index2 = segments.indexOf('product');
    if (index2 != -1 && index2 + 1 < segments.length) {
      return int.tryParse(segments[index2 + 1]);
    }

    // ?product_id=10
    return int.tryParse(uri.queryParameters['product_id'] ?? '');
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'title': title,
    'description': description,
    'image_url': imageUrl,
    'brand_logo_url': brandLogoUrl,
    'link': link,
    'link_text': linkText,
    'position': position,
    'sequence': sequence,
    'active': active,
    'text_color': textColor,
    'product_price': productPrice,
  };

  bool get hasProduct => productId != null;
  bool get isActive => active ?? false;
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
}
