// app_providers.dart

import 'package:buynuk/core/services/api_service.dart';
import 'package:buynuk/presentation/auth/controllers/auth_provider.dart';
import 'package:buynuk/presentation/auth/domain/repository/auth_repo.dart';
import 'package:buynuk/presentation/auth/domain/services/auth_service.dart';
import 'package:buynuk/presentation/cart/controllers/cart_provider.dart';
import 'package:buynuk/presentation/cart/domain/repository/cart_repo.dart';
import 'package:buynuk/presentation/cart/domain/services/cart_service.dart';
import 'package:buynuk/presentation/flash_sales/controllers/flashSales_provider.dart' show FlashSalesProvider;
import 'package:buynuk/presentation/flash_sales/domain/repository/flashSales_repo.dart';
import 'package:buynuk/presentation/flash_sales/domain/services/flashSales_service.dart';
import 'package:buynuk/presentation/help_support/controllers/help_support_provider.dart';
import 'package:buynuk/presentation/help_support/domain/repository/help_support_repo.dart';
import 'package:buynuk/presentation/help_support/domain/services/help_support_service.dart';
import 'package:buynuk/presentation/home/controllers/home_provider.dart';
import 'package:buynuk/presentation/home/domain/repository/home_repo.dart';
import 'package:buynuk/presentation/home/domain/services/home_service.dart';
import 'package:buynuk/presentation/language/language_provider.dart';
import 'package:buynuk/presentation/newArrival/controllers/newArrival_provider.dart';
import 'package:buynuk/presentation/newArrival/domain/repository/newArrival_repo.dart';
import 'package:buynuk/presentation/newArrival/domain/services/newArrival_service.dart';
import 'package:buynuk/presentation/orders/controllers/orders_provider.dart';
import 'package:buynuk/presentation/orders/domain/repository/orders_repo.dart' show OrdersRepository;
import 'package:buynuk/presentation/orders/domain/services/orders_service.dart';
import 'package:buynuk/presentation/payment_methods/controllers/payment_provider.dart';
import 'package:buynuk/presentation/profile/controllers/profile_provider.dart';
import 'package:buynuk/presentation/profile/domain/repository/profile_repo.dart';
import 'package:buynuk/presentation/profile/domain/services/profile_service.dart';
import 'package:buynuk/presentation/wishlist/controllers/wishlist_provider.dart';
import 'package:buynuk/presentation/wishlist/domain/repository/wishlist_repo.dart';
import 'package:buynuk/presentation/wishlist/domain/services/wishlist_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> buildProviders(LanguageProvider languageProvider) => [
  ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),

  //  Auth ----------------------------------------------------------
  ChangeNotifierProvider(
    create: (_) => AuthProvider(
      authService: AuthService(authRepository: AuthRepository(apiClient: ApiClient())),
    ),
  ),

  //  Home ----------------------------------------------------------
  ChangeNotifierProvider(
    create: (_) => HomeProvider(
      homeService: HomeService(homeRepository: HomeRepository(apiClient: ApiClient())),
    ),
  ),

  //  NewArrival  ----------------------------------------------------------
  ChangeNotifierProvider(
    create: (_) => NewArrivalProvider(
      newArrivalService: NewArrivalService(
        newArrivalRepository: NewArrivalRepository(apiClient: ApiClient()),
      ),
    ),
  ),

  //  wishlist  ----------------------------------------------------------
  ChangeNotifierProvider(
    create: (_) => WishlistProvider(
      wishlistService: WishlistService(wishlistRepository: WishlistRepository(apiClient: ApiClient())),
    ),
  ),

  // cart  ----------------------------------------------------------
  ChangeNotifierProvider(
    create: (_) => CartProvider(
      cartService: CartService(cartRepository: CartRepository(apiClient: ApiClient())),
    ),
  ),

  //  orders --------------------------------------------------------
  ChangeNotifierProvider(
    create: (_) => OrdersProvider(
      ordersService: OrdersService(ordersRepository: OrdersRepository(apiClient: ApiClient())),
    ),
  ),

  // Profile --------------------------------------------------------
  ChangeNotifierProvider(
    create: (_) => ProfileProvider(
      profileService: ProfileService(profileRepository: ProfileRepository(apiClient: ApiClient())),
    ),
  ),

  // FlashSalesProvider --------------------------------------------------------
  ChangeNotifierProvider(
    create: (_) => FlashSalesProvider(
      flashSalesService: FlashSalesService(
        flashSalesRepository: FlashSalesRepository(apiClient: ApiClient()),
      ),
    ),
  ),

  // PaymentProvider --------------------------------------------------------
  ChangeNotifierProvider(create: (_) => PaymentProvider()),

  // HelpSupportProvider --------------------------------------------------------
  ChangeNotifierProvider(
    create: (_) => HelpSupportProvider(
      helpSupportService: HelpSupportService(
        helpSupportRepository: HelpSupportRepository(apiClient: ApiClient()),
      ),
    ),
  ),
];
