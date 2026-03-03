// ignore_for_file: non_constant_identifier_names

import 'package:buynuk/presentation/home/domain/models/banners_model.dart';
import 'package:buynuk/presentation/home/domain/models/categories_model.dart';
import 'package:buynuk/presentation/home/domain/models/products_model.dart';
import 'package:buynuk/presentation/home/domain/repository/home_repo.dart';

class HomeService {
  final HomeRepository homeRepository;

  HomeService({required this.homeRepository});

  // -----------------------------------------------------------------------
  /// Banners
  // -----------------------------------------------------------------------

  Future<BannersModel> getBanners() async {
    return await homeRepository.getBanners();
  }

  // -----------------------------------------------------------------------
  /// Banners  id
  /// -----------------------------------------------------------------------

  Future<Products> getBannersProducts_id(int bannerId) async {
    return await homeRepository.getBannersProducts_id(bannerId);
  }

  // -----------------------------------------------------------------------
  /// Categories
  // -----------------------------------------------------------------------

  Future<CategoriesModel> getAllCategories() async {
    return await homeRepository.getAllCategories();
  }

  // -----------------------------------------------------------------------
  /// Products
  // -----------------------------------------------------------------------

  Future<ProductsModel> getAllProducts() async {
    return await homeRepository.getAllProducts();
  }

  // -----------------------------------------------------------------------
  /// Products  id
  // -----------------------------------------------------------------------

  Future<ProductsModel> getProductsId(String categoryId) async {
    return await homeRepository.getProductsId(categoryId);
  }

  // -----------------------------------------------------------------------
  /// Search  id
  // -----------------------------------------------------------------------

  Future<ProductsModel> getSearch_Home(String categoryId) async {
    return await homeRepository.getSearch_Home(categoryId);
  }

  // -----------------------------------------------------------------------
  /// Best Selling
  // -----------------------------------------------------------------------

  Future<ProductsModel> getBest_selling() async {
    return await homeRepository.getBest_selling();
  }
}
