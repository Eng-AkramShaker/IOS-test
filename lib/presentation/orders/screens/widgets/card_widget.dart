// ignore_for_file: deprecated_member_use

import 'package:buynuk/core/constants/app_colors.dart';
import 'package:buynuk/core/services/language/string_extension.dart';
import 'package:buynuk/presentation/orders/domain/models/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCard extends StatelessWidget {
  final Orders order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final stateColor = _getStateColor(order.state ?? '');
    final currency = order.currencySymbol ?? order.currency ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // ── أيقونة يسار ──────────────────────────
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // ── المعلومات الرئيسية ───────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // رقم الطلب + بادج الحالة
                  Row(
                    children: [
                      Text(
                        order.name ?? '#${order.id}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1F36),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: stateColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: stateColor.withOpacity(0.25)),
                        ),
                        child: Text(
                          order.stateLabel ?? order.state ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: stateColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // التاريخ + عدد المنتجات
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(order.dateOrder),
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: Colors.grey[400]),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.inventory_2_outlined,
                          size: 12, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        '${order.itemsCount ?? 0} ${'items'.tr}',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── السعر الإجمالي يمين ──────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$currency ${order.amountTotal?.toStringAsFixed(2) ?? '0.00'}',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${'tax'.tr}: $currency ${order.amountTax?.toStringAsFixed(2) ?? '0.00'}',
                  style: GoogleFonts.poppins(
                      fontSize: 10, color: Colors.grey[400]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null) return 'N/A';
    try {
      final dt = DateTime.parse(raw);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return raw;
    }
  }

  Color _getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'sale':   return Colors.green;
      case 'draft':  return Colors.orange;
      case 'cancel': return Colors.red;
      case 'done':   return Colors.blue;
      default:       return AppColors.primary;
    }
  }
}
