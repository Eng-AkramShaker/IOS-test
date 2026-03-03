class AppConstants {
  AppConstants._();

  static const String baseUrl = "https://buynuk.com/api";

  static const String img = "https://buynuk.com";

  // -----------------------------------------------------------------------
  /// Auth
  // -----------------------------------------------------------------------
  static const String loginUri = "/login";
  static const String signupUri = "/signup/http";

  static const String logoutUri = "/auth/logout";

  //  Password Management
  static const String forgotPasswordUri = '/auth/forgot_password';
  static const String changePasswordUri = '/profile/change_password';

  // -----------------------------------------------------------------------
  /// Products & Catalog
  // -----------------------------------------------------------------------

  static const String bannersUri = "/hero_slider";

  static const String bannersProductsUri = "/products/";

  static const String categoriesUri = "/categories?type=browse_boxes";
  static const String productsUri = "/products";
  static const String productsIdUri = "/products?category_id=";
  static const String bestSellingUri = "/best_selling";
  static const String searchUri = "/search?q=";
  static const String newArrivalsUri = "/new_arrivals";

  static const String flashSalesUri = "/flash_sales";

  // -----------------------------------------------------------------------
  ///   Wishlist
  // -----------------------------------------------------------------------
  static const String wishlistUri = "/wishlist";
  static const String wishlistAddUri = "/wishlist/add";
  static const String wishlistRemoveUri = "/wishlist/remove";

  // -----------------------------------------------------------------------
  /// Cart
  // -----------------------------------------------------------------------
  static const String cartUri = "/cart";
  static const String addToCartUri = "/cart/add";
  static const String cartItemUri = "/cart/item";
  static const String cartDeleteUri = "/cart/item";

  // -----------------------------------------------------------------------
  /// Orders & Checkout
  // -----------------------------------------------------------------------
  static const String checkoutUri = "/checkout";
  static const String ordersUri = "/orders";
  static const String quotationsUri = "/quotations";

  // -----------------------------------------------------------------------
  /// Profile
  // -----------------------------------------------------------------------
  static const String profileUri = "/profile";
  static const String editProfileUri = "/profile/edit";

  // -----------------------------------------------------------------------
  /// Addresses
  // -----------------------------------------------------------------------
  static const String addressesUri = "/addresses";

  // -----------------------------------------------------------------------
  /// Promotions & Marketing
  // -----------------------------------------------------------------------
  static const String marketSlidesUri = "/market/slides";
  static const String promoOfferUri = "/promo-offer";
  static const String heroSectionUri = "/hero-section";

  // -----------------------------------------------------------------------
  /// Payment - MyFatoorah
  // -----------------------------------------------------------------------
  static const String myFatoorahInitiateUri = "/payment/myfatoorah/initiate";
  static const String myFatoorahExecuteUri = "/payment/myfatoorah/execute";
  static const String myFatoorahStatusUri = "/payment/myfatoorah/status";

  // -----------------------------------------------------------------------
  /// Locations
  // -----------------------------------------------------------------------
  static const String countriesUri = "/countries";
  static const String statesUri = "/states";
  static const String citiesUri = "/cities";

  // -----------------------------------------------------------------------
  /// Settings
  // -----------------------------------------------------------------------
  static const String currenciesUri = "/currencies";
  static const String languagesUri = "/languages";

  // -----------------------------------------------------------------------
  /// Other
  // -----------------------------------------------------------------------
  static const String paymentMethodsUri = "/payment-methods";
  static const String uomUri = "/uom";
  static const String aboutUri = "/about";
  static const String contactUri = "/contact";

  // -----------------------------------------------------------------------
  /// Help & Support
  // -----------------------------------------------------------------------
  static const String privacyPolicyUri = "/legal/privacy";
  static const String termsUri = "/legal/terms";
}
