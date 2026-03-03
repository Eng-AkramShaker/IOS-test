import 'package:buynuk/core/constants/app_constants.dart';
import 'package:buynuk/presentation/home/domain/models/products_model.dart';
import 'package:flutter/material.dart';

class HomeSearchOverlay {
  OverlayEntry? _overlayEntry;

  void remove() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void show({
    required BuildContext context,
    required LayerLink layerLink,
    required List<Products?> results,
    required VoidCallback onClear,
  }) {
    remove();

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: layerLink,
          offset: const Offset(0, 58),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 350),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: results.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('لا توجد نتائج', style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
                      itemBuilder: (_, index) {
                        final product = results[index];
                        return _SearchResultItem(product: product, onTap: onClear);
                      },
                    ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
}

class _SearchResultItem extends StatelessWidget {
  final Products? product;
  final VoidCallback onTap;

  const _SearchResultItem({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          "${AppConstants.img}${product?.image ?? ''}",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 50,
            height: 50,
            color: Colors.grey[100],
            child: Icon(Icons.image, color: Colors.grey[400]),
          ),
        ),
      ),
      title: Text(
        product?.name ?? '',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "${product?.price} ${product?.currency ?? ''}",
        style: const TextStyle(fontSize: 12, color: Colors.amber, fontWeight: FontWeight.w700),
      ),
    );
  }
}
