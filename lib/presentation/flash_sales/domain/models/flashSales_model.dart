import 'package:buynuk/presentation/home/domain/models/products_model.dart';

class FlashSalesModel {
  final bool? success;
  final FlashData? data;

  FlashSalesModel({this.success, this.data});

  factory FlashSalesModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return FlashSalesModel(
      success: json['success'],
      data: json['data'] != null ? FlashData.fromJson(json['data']) : null,
    );
  }
}

class FlashData {
  final Promotion? promotion;
  final List<Products>? products;
  final num? total;

  FlashData({this.promotion, this.products, this.total});

  factory FlashData.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return FlashData(
      promotion: json['promotion'] != null ? Promotion.fromJson(json['promotion']) : null,
      products: json['products'] != null
          ? List<Products>.from(json['products'].map((e) => Products.fromJson(e)))
          : [],
      total: json['total'],
    );
  }
}

class Promotion {
  final num? id;
  final String? name;
  final String? endDate;
  final String? startDate;

  Promotion({this.id, this.name, this.endDate, this.startDate});

  factory Promotion.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Promotion(
      id: json['id'],
      name: json['name'],
      endDate: json['end_date'],
      startDate: json['start_date'],
    );
  }
}
