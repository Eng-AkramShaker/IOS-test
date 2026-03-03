// ignore_for_file: deprecated_member_use

import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/constants/app_constants.dart';
import 'package:buynuk/presentation/flash_sales/domain/models/flashSales_model.dart';
import 'package:flutter/material.dart';

class FlashSalesCard extends StatelessWidget {
  final FlashSalesModel item;
  final VoidCallback? onTap;

  const FlashSalesCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───   ───────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                "${AppConstants.img} ",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : SizedBox(
                        height: 140,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      ),
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  color: Colors.grey[100],
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey[400]),
                ),
              ),
            ),

            // ───   ────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "",
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // if (item.desc != null && item.desc!.isNotEmpty) ...[
                  //   const SizedBox(height: 2),
                  //   Text(
                  //   "",
                  //     style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  //     maxLines: 1,
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ],
                  // const SizedBox(height: 10),
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 32,
                  //   child: ElevatedButton(
                  //     onPressed: onTap,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.amber,
                  //       elevation: 0,
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  //     ),
                  //     child: const Text(
                  //       "تسوق الآن",
                  //       style: TextStyle(fontSize: 11, color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
