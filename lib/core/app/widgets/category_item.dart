import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final String img;

  const CategoryItem({super.key, required this.name, required this.img});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.network(
                img,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                },
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image_outlined, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
