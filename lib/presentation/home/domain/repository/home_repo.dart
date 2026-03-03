// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'dart:convert';
import 'package:buynuk/core/services/api_service.dart';
import 'package:buynuk/presentation/home/domain/models/banners_model.dart';
import 'package:buynuk/presentation/home/domain/models/categories_model.dart';
import 'package:buynuk/presentation/home/domain/models/products_model.dart';
import 'package:buynuk/presentation/home/domain/models/single_product_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

class HomeRepository {
  final ApiClient apiClient;

  HomeRepository({required this.apiClient});

  // -----------------------------------------------------------------------
  /// Banners
  // -----------------------------------------------------------------------

  Future<BannersModel> getBanners() async {
    final http.Response response = await apiClient.getData(AppConstants.bannersUri);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return BannersModel.fromJson(json);
  }

  // -----------------------------------------------------------------------
  /// Banners  id
  // -----------------------------------------------------------------------

  Future<Products> getBannersProducts_id(int bannerId) async {
    final http.Response response = await apiClient.getData('${AppConstants.bannersProductsUri}$bannerId');
    final Map<String, dynamic> json = jsonDecode(response.body);
    return SingleProductModel.fromJson(json).data!;
  }

  // -----------------------------------------------------------------------
  /// Categories
  // -----------------------------------------------------------------------

  Future<CategoriesModel> getAllCategories() async {
    final http.Response response = await apiClient.getData(AppConstants.categoriesUri);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return CategoriesModel.fromJson(json);
  }

  // -----------------------------------------------------------------------
  /// Products
  // -----------------------------------------------------------------------

  Future<ProductsModel> getAllProducts() async {
    final http.Response response = await apiClient.getData(AppConstants.productsUri);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return ProductsModel.fromJson(json);
  }

  // -----------------------------------------------------------------------
  /// Products id
  // -----------------------------------------------------------------------

  Future<ProductsModel> getProductsId(String categoryId) async {
    final http.Response response = await apiClient.getData(AppConstants.productsIdUri + categoryId);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return ProductsModel.fromJson(json);
  }

  // -----------------------------------------------------------------------
  /// Search
  // -----------------------------------------------------------------------

  Future<ProductsModel> getSearch_Home(String name) async {
    final http.Response response = await apiClient.getData(AppConstants.searchUri + name);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return ProductsModel.fromJson(json);
  }

  // -----------------------------------------------------------------------
  ///  Best selling
  // -----------------------------------------------------------------------

  Future<ProductsModel> getBest_selling() async {
    final http.Response response = await apiClient.getData(AppConstants.bestSellingUri);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return ProductsModel.fromJson(json);
  }
}
