// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/home/controllers/home_provider.dart';
import 'package:buynuk/presentation/home/widget/home_banner.dart';
import 'package:buynuk/presentation/home/widget/home_best_selling.dart';
import 'package:buynuk/presentation/home/widget/home_categories.dart';
import 'package:buynuk/presentation/home/widget/home_explore_products.dart';
import 'package:buynuk/presentation/home/widget/home_header.dart';
import 'package:buynuk/presentation/home/widget/search/home_search_handler.dart';
import 'package:buynuk/presentation/home/widget/search/home_search_overlay.dart';
import 'package:buynuk/presentation/profile/controllers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _bannerIndexNotifier = ValueNotifier(0);
  final TextEditingController _searchCtrl = TextEditingController();
  final ValueNotifier<bool> _hasSearchText = ValueNotifier(false);
  final LayerLink _layerLink = LayerLink();
  final HomeSearchOverlay _searchOverlay = HomeSearchOverlay();
  late final HomeSearchHandler _searchHandler;

  @override
  void initState() {
    super.initState();

    _searchHandler = HomeSearchHandler(
      searchCtrl: _searchCtrl,
      layerLink: _layerLink,
      searchOverlay: _searchOverlay,
      isMounted: () => mounted,
    );

    _searchCtrl.addListener(() {
      _hasSearchText.value = _searchCtrl.text.isNotEmpty;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHome();
      context.read<ProfileProvider>().getProfile();
    });
  }

  @override
  void dispose() {
    _searchHandler.dispose();
    _searchCtrl.dispose();
    _hasSearchText.dispose();
    _bannerIndexNotifier.dispose();
    _searchOverlay.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final homeProvider = context.watch<HomeProvider>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            HomeHeader(
              name: profileProvider.userProfileModel?.name ?? "guest".tr,
              searchController: _searchCtrl,
              hasSearchText: _hasSearchText,
              layerLink: _layerLink,
              onSearchChanged: (value) => _searchHandler.onSearchChanged(value, context),
              onSearch: () => _searchHandler.onSearchTap(context),
              onClear: () {
                _searchCtrl.clear();
                _hasSearchText.value = false;
                _searchOverlay.remove();
              },
            ),
            homeProvider.isLoadingHome
                ? const Expanded(child: Center(child: LoadingWidget()))
                : Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => homeProvider.loadHome(),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HomeBanner(homeProvider: homeProvider, bannerIndexNotifier: _bannerIndexNotifier),
                            const SizedBox(height: 5),
                            HomeCategories(homeProvider: homeProvider),
                            const SizedBox(height: 5),
                            HomeBestSelling(homeProvider: homeProvider),
                            const SizedBox(height: 30),
                            HomeExploreProducts(homeProvider: homeProvider),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
