import 'package:buynuk/presentation/home/domain/models/products_model.dart';

class SingleProductModel {
  final bool? success;
  final Products? data;

  SingleProductModel({this.success, this.data});

  factory SingleProductModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return SingleProductModel(
      success: json['success'],
      data: json['data'] != null ? Products.fromJson(json['data']) : null,
    );
  }
}
