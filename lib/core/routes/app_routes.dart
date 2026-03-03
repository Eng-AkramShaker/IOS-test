// ignore_for_file: non_constant_identifier_names

import 'package:buynuk/presentation/auth/screens/login_screen.dart';
import 'package:buynuk/presentation/flash_sales/screens/flashSales_screen.dart';
import 'package:buynuk/presentation/help_support/screens/legal_screen.dart';
import 'package:buynuk/presentation/home/domain/models/products_model.dart';
import 'package:buynuk/presentation/home/screens/products/all_products_screen.dart';
import 'package:buynuk/presentation/home/screens/home_screen.dart';
import 'package:buynuk/presentation/home/screens/products/products_screen.dart';
import 'package:buynuk/core/app/widgets/navigationBar/main_navigation_screen.dart';
import 'package:buynuk/presentation/home/screens/products/product_details_screen.dart';
import 'package:buynuk/presentation/newArrival/screens/new_arrivals_screen.dart';
import 'package:buynuk/presentation/orders/screens/orders_screen.dart';
import 'package:buynuk/presentation/profile/screens/personal_info_screen.dart';
import 'package:buynuk/presentation/splash/splash_screen.dart';
import 'package:buynuk/presentation/language/languageScreen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  static const String mainNavigation = '/main_navigation';
  static const String home = '/home';
  static const String language = '/language';
  static const String products = '/products';
  static const String productDetails = '/product_details';
  static String new_arrivalsScreen = '/new_arrivals';
  static String all_productsScreen = '/all_products';

  static String personalInfoScreen = '/personal_info';
  static String ordersScreen = '/orders';
  static String flashSalesScreen = '/ flashSales';

  static String legalScreen = '/legal_screen';

  // =============================================================================

  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    mainNavigation: (_) => const MainNavigationScreen(),
    home: (_) => const HomeScreen(),
    language: (_) => LanguageScreen(fromProfile: false),

    products: (context) => ProductsScreen(categoryId: ModalRoute.of(context)!.settings.arguments as String),
    productDetails: (context) =>
        ProductDetailsScreen(product: ModalRoute.of(context)!.settings.arguments as Products),
    new_arrivalsScreen: (_) => const New_ArrivalsScreen(),
    all_productsScreen: (_) => const AllProductsScreen(),

    personalInfoScreen: (_) => const PersonalInfoScreen(),
    ordersScreen: (context) =>
        OrdersScreen(inPageProfile: (ModalRoute.of(context)?.settings.arguments as bool?) ?? false),
    flashSalesScreen: (_) => const FlashSalesScreen(),
    legalScreen: (context) => LegalScreen(type: ModalRoute.of(context)!.settings.arguments as String),
  };
}
