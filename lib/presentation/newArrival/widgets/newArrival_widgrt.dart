// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/constants/app_constants.dart';
import 'package:buynuk/presentation/newArrival/domain/models/newArrival_model.dart';
import 'package:flutter/material.dart';

class NewArrivalCard extends StatelessWidget {
  final NewArrivalItem item;
  final VoidCallback? onTap;

  const NewArrivalCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        final imageHeight = cardWidth * 0.75;

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
                // ───  الصورة ───────────────────────────────
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    "${AppConstants.img}${item.image ?? ''}",
                    height: imageHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : SizedBox(
                            height: imageHeight,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2.5,
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          ),
                    errorBuilder: (_, __, ___) => Container(
                      height: imageHeight,
                      color: Colors.grey[100],
                      child: Icon(Icons.broken_image, size: cardWidth * 0.15, color: Colors.grey[400]),
                    ),
                  ),
                ),

                // ───  المحتوى ──────────────────────────────
                Expanded(
                  child: Center(
                    child: Text(
                      item.name ?? "",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
