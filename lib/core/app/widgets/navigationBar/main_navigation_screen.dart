import 'package:buynuk/presentation/flash_sales/screens/flashSales_screen.dart';
import 'package:buynuk/presentation/orders/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import '../../../../presentation/home/screens/home_screen.dart';
import '../../../../presentation/wishlist/screens/wishlist_screen.dart';
import '../../../../presentation/newArrival/screens/new_arrivals_screen.dart';
import '../../../../presentation/cart/screens/cart_screen.dart';
import '../../../../presentation/profile/screens/profile_screen.dart';
import 'bottom_navigation_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 3; // الهوم هو الافتراضي

  int _storeRefreshKey = 0;
  int _ordersRefreshKey = 0;
  int _wishlistRefreshKey = 0;
  int _homeRefreshKey = 0;
  int _flashRefreshKey = 0;
  int _cartRefreshKey = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          New_ArrivalsScreen(key: ValueKey(_storeRefreshKey)),

          OrdersScreen(key: ValueKey(_ordersRefreshKey), inPageProfile: false),

          WishlistScreen(key: ValueKey(_wishlistRefreshKey)),

          HomeScreen(key: ValueKey(_homeRefreshKey)),

          FlashSalesScreen(key: ValueKey(_flashRefreshKey)),

          CartScreen(key: ValueKey(_cartRefreshKey)),

          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 0) _storeRefreshKey++;
            if (index == 1) _ordersRefreshKey++;
            if (index == 2) _wishlistRefreshKey++;
            if (index == 3) _homeRefreshKey++;
            if (index == 4) _flashRefreshKey++;
            if (index == 5) _cartRefreshKey++;
          });
        },
      ),
    );
  }
}
