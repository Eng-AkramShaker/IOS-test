// ignore_for_file: deprecated_member_use, unnecessary_underscores, must_be_immutable

import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/presentation/orders/controllers/orders_provider.dart';
import 'package:buynuk/presentation/orders/screens/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';

class OrdersScreen extends StatefulWidget {
  bool inPageProfile = false;
  OrdersScreen({super.key, required this.inPageProfile});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, provider, _) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.backgroundLight,
            appBar: widget.inPageProfile
                ? buildAppBar(context, "myOrders".tr, showBottom: true)
                : buildAppBar(context, "myOrders".tr),

            body: provider.isLoading
                ? const Center(child: LoadingWidget())
                : provider.errorMessage != null
                ? _buildError(provider)
                : provider.ordersModel == null
                ? _buildEmpty()
                : _buildList(provider),
          ),
        );
      },
    );
  }

  Widget _buildList(OrdersProvider provider) {
    final orders = provider.ordersModel?.data?.orders ?? [];
    return orders.isEmpty
        ? _buildEmpty()
        : RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => provider.getOrders(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) {
                final order = orders[index];
                if (order == null) return const SizedBox();
                return OrderCard(order: order);
              },
            ),
          );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'noOrders'.tr,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[500]),
          ),
          const SizedBox(height: 6),
          Text('noOrdersSubtitle'.tr, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400])),
        ],
      ),
    );
  }

  // ── خطأ ──────────────────────────────────────────────────────
  Widget _buildError(OrdersProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 14),
          Text('somethingWentWrong'.tr, style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[500])),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => provider.getOrders(),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text('retry'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
