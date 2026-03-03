import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/home/widget/search/home_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final TextEditingController searchController;
  final ValueNotifier<bool> hasSearchText;
  final LayerLink layerLink;
  final Function(String) onSearchChanged;
  final VoidCallback onSearch;
  final VoidCallback onClear;

  const HomeHeader({
    super.key,
    required this.name,
    required this.searchController,
    required this.hasSearchText,
    required this.layerLink,
    required this.onSearchChanged,
    required this.onSearch,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      '${'hello'.tr}  $name!',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          HomeSearchBar(
            controller: searchController,
            hasSearchText: hasSearchText,
            layerLink: layerLink,
            onChanged: onSearchChanged,
            onSearch: onSearch,
            onClear: onClear,
          ),
        ],
      ),
    );
  }
}
