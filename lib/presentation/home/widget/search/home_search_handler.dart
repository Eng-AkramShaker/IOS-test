import 'dart:async';
import 'package:buynuk/presentation/home/controllers/home_provider.dart';
import 'package:buynuk/presentation/home/widget/search/home_search_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeSearchHandler {
  final TextEditingController searchCtrl;
  final LayerLink layerLink;
  final HomeSearchOverlay searchOverlay;
  final bool Function() isMounted;

  Timer? _debounceTimer;

  HomeSearchHandler({
    required this.searchCtrl,
    required this.layerLink,
    required this.searchOverlay,
    required this.isMounted,
  });

  void dispose() {
    _debounceTimer?.cancel();
  }

  // ─── البحث عند كل حرف ──────────────────────────────────────

  void onSearchChanged(String value, BuildContext context) {
    _debounceTimer?.cancel();

    if (value.isEmpty) {
      searchOverlay.remove();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      await _search(context, value);
    });
  }

  // ─── البحث عند الضغط على أيقونة البحث ─────────────────────

  void onSearchTap(BuildContext context) async {
    if (searchCtrl.text.isNotEmpty) {
      _debounceTimer?.cancel();
      await _search(context, searchCtrl.text);
    }
  }

  // ─── منطق البحث المشترك ────────────────────────────────────

  Future<void> _search(BuildContext context, String value) async {
    final homeProvider = context.read<HomeProvider>();
    await homeProvider.getSearch_Home(value);
    final results = homeProvider.searchModel?.data?.products ?? [];

    if (isMounted()) {
      searchOverlay.show(
        context: context,
        layerLink: layerLink,
        results: results,
        onClear: () {
          searchOverlay.remove();
          searchCtrl.clear();
        },
      );
    }
  }
}
