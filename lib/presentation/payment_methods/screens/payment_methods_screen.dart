// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:buynuk/core/app/widgets/loading_widget.dart';
import 'package:buynuk/presentation/payment_methods/controllers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:myfatoorah_flutter/MFModels.dart';
import 'package:provider/provider.dart';

void showPaymentMethodsSheet({
  required BuildContext context,
  required double amount, // ✅ نمرر المبلغ هنا
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (buildContext) => Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),

          // العنوان
          const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.payment, color: Colors.blue, size: 26),
                SizedBox(width: 12),
                Text('اختر وسيلة الدفع', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          const Divider(height: 1),

          // قائمة وسائل الدفع
          Expanded(
            child: Consumer<PaymentProvider>(
              builder: (_, p, __) {
                if (p.loading) {
                  return const Center(child: LoadingWidget());
                }

                if (p.methods.isEmpty) {
                  return const Center(child: Text('لا توجد وسائل دفع متاحة'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: p.methods.length,
                  itemBuilder: (_, i) {
                    final method = p.methods[i];
                    return _buildPaymentMethodCard(
                      buildContext,
                      method,
                      p,
                      amount, // ✅ نمرره هنا
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPaymentMethodCard(
  BuildContext context,
  MFPaymentMethod method,
  PaymentProvider provider,
  double amount, // ✅ استقباله هنا
) {
  return InkWell(
    onTap: () async {
      Navigator.pop(context);
      await provider.executePayment(
        context,
        method,
        amount, // ✅ استخدامه هنا
      );
    },
    borderRadius: BorderRadius.circular(20),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          SizedBox(
            width: 70,
            height: 70,
            child: method.imageUrl != null && method.imageUrl!.isNotEmpty
                ? Image.network(
                    method.imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.account_balance_wallet),
                  )
                : const Icon(Icons.account_balance_wallet),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              method.paymentMethodAr ?? method.paymentMethodEn ?? "وسيلة دفع",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}
