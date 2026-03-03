import 'package:buynuk/presentation/home/domain/models/banners_model.dart';
import 'package:buynuk/presentation/home/domain/models/categories_model.dart';
import 'package:buynuk/presentation/home/domain/models/products_model.dart';
import 'package:buynuk/presentation/home/domain/services/home_service.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  HomeService _homeService;

  HomeProvider({required HomeService homeService}) : _homeService = homeService;

  void updateService(HomeService service) {
    _homeService = service;
  }

  // -----------------------------------------------------------------------
  /// State
  // -----------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingHome = false;
  bool get isLoadingHome => _isLoadingHome;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  BannersModel? _bannersModel;
  BannersModel? get bannersModel => _bannersModel;

  // ✅ متغيرات البانر المنتج
  Products? _bannerProduct;
  Products? get bannerProduct => _bannerProduct;

  bool _isLoadingBannerProduct = false;
  bool get isLoadingBannerProduct => _isLoadingBannerProduct;

  CategoriesModel? _categoriesModel;
  CategoriesModel? get categoriesModel => _categoriesModel;

  ProductsModel? _productsModel;
  ProductsModel? get productsModel => _productsModel;

  bool _isLoading_productsId = false;
  bool get isLoading_productsId => _isLoading_productsId;

  ProductsModel? _productsIdModel;
  ProductsModel? get productsIdModel => _productsIdModel;

  bool _isLoading_Search = false;
  bool get isLoading_Search => _isLoading_Search;

  ProductsModel? _searchModel;
  ProductsModel? get searchModel => _searchModel;

  ProductsModel? _bestSellingModel;
  ProductsModel? get bestSellingModel => _bestSellingModel;

  // -----------------------------------------------------------------------
  /// getBanners
  // -----------------------------------------------------------------------

  Future<void> getBanners() async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      _bannersModel = await _homeService.getBanners();
      _notify();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  // -----------------------------------------------------------------------
  /// getBanner Id
  // -----------------------------------------------------------------------

  Future<void> getBannerProductById(int productId) async {
    _isLoadingBannerProduct = true;
    _bannerProduct = null;
    _notify();

    try {
      _bannerProduct = await _homeService.getBannersProducts_id(productId);
      _notify();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error getBannerProductById: $e');
    } finally {
      _isLoadingBannerProduct = false;
      _notify();
    }
  }
  // -----------------------------------------------------------------------
  /// getAllCategories
  // -----------------------------------------------------------------------

  Future<void> getAllCategories() async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      _categoriesModel = await _homeService.getAllCategories();
      debugPrint('Provider model null?: ${_categoriesModel == null}');
      debugPrint('Provider categories: ${_categoriesModel?.data?.categories?.length}');
      _notify();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  // -----------------------------------------------------------------------
  /// get Products
  // -----------------------------------------------------------------------

  Future<void> getAllProducts() async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      _productsModel = await _homeService.getAllProducts();
      _notify();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  // -----------------------------------------------------------------------
  /// get Product id
  // -----------------------------------------------------------------------

  Future<void> getProductsId(String categoryId) async {
    _isLoading_productsId = true;
    _errorMessage = null;
    _notify();

    try {
      _productsIdModel = await _homeService.getProductsId(categoryId);
      _notify();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error: $e');
    } finally {
      _isLoading_productsId = false;
      _notify();
    }
  }

  // -----------------------------------------------------------------------
  ///  get Search
  // -----------------------------------------------------------------------

  Future<void> getSearch_Home(String categoryId) async {
    _isLoading_Search = true;
    _errorMessage = null;
    _notify();

    try {
      _searchModel = await _homeService.getSearch_Home(categoryId);
      _notify();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error: $e');
    } finally {
      _isLoading_Search = false;
      _notify();
    }
  }

  // -----------------------------------------------------------------------
  ///   get Best Selling
  // -----------------------------------------------------------------------

  Future<void> getBest_selling() async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      _bestSellingModel = await _homeService.getBest_selling();
      _notify();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  // -----------------------------------------------------------------------
  ///   loadHome
  // -----------------------------------------------------------------------

  Future<void> loadHome() async {
    _isLoadingHome = true;
    _errorMessage = null;
    _notify();

    try {
      await getBanners();
      await getAllCategories();
      await getAllProducts();
      await getBest_selling();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('loadHome Error: $e');
    } finally {
      _isLoadingHome = false;
      _notify();
    }
  }

  //  التحقق قبل الإشعار -------------------------------------------

  bool _disposed = false;
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
