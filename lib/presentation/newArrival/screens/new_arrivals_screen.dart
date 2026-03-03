// ignore_for_file: camel_case_types

import 'package:buynuk/core/app/widgets/appBar_widget.dart';
import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/newArrival/controllers/newArrival_provider.dart';
import 'package:buynuk/presentation/newArrival/domain/models/newArrival_model.dart';
import 'package:buynuk/presentation/newArrival/widgets/newArrival_widgrt.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class New_ArrivalsScreen extends StatefulWidget {
  const New_ArrivalsScreen({super.key});

  @override
  State<New_ArrivalsScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<New_ArrivalsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewArrivalProvider>().geNewArrival();
    });
  }

  @override
  Widget build(BuildContext context) {
    final newArrivalProvider = context.watch<NewArrivalProvider>();
    final data = newArrivalProvider.newArrivalModel?.data;

    final List<NewArrivalItem> items = [
      if (data?.big != null) data!.big!,
      if (data?.medium != null) data!.medium!,
      if (data?.smallSpeakers != null) data!.smallSpeakers!,
      if (data?.smallPerfume != null) data!.smallPerfume!,
    ];

    final filteredItems = _searchController.text.isEmpty
        ? items
        : items.where((item) {
            final query = _searchController.text.toLowerCase();
            return (item.name ?? '').toLowerCase().contains(query) ||
                (item.desc ?? '').toLowerCase().contains(query);
          }).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: buildAppBar(context, "newArrival".tr),

        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            newArrivalProvider.isLoading
                ? Expanded(child: const Center(child: LoadingWidget()))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        if (filteredItems.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Column(
                              children: [
                                Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[400]),
                                const SizedBox(height: 12),
                                Text(
                                  'no_products'.tr,
                                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                return NewArrivalCard(item: filteredItems[index], onTap: () {});
                              },
                            ),
                          ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
