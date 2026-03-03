import 'package:buynuk/core/constants/app_constants.dart';
import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/home/controllers/home_provider.dart';
import 'package:buynuk/presentation/home/domain/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app/widgets/category_item.dart';

class HomeCategories extends StatelessWidget {
  final HomeProvider homeProvider;

  const HomeCategories({super.key, required this.homeProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'browseByCategory'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeProvider.categoriesModel?.data?.categories?.length ?? 0,
            itemBuilder: (_, i) {
              final Categories? category = homeProvider.categoriesModel?.data?.categories?[i];
              if (category == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SizedBox(
                  width: 80,
                  child: GestureDetector(
                    onTap: () => push(AppRoutes.products, arguments: category.categoryId.toString()),
                    child: CategoryItem(
                      name: category.name ?? '',
                      img: '${AppConstants.img}${category.icon}',
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
