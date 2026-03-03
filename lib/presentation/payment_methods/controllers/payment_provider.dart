// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:buynuk/core/app/widgets/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

class PaymentProvider extends ChangeNotifier {
  bool loading = false;
  List<MFPaymentMethod> methods = [];
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // ============================================================
  // Init Payment Methods
  // ============================================================

  Future<void> init(num amount) async {
    loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await MFSDK.init(
        "SK_KWT_vVZlnnAqu8jRByOWaRPNId4ShzEDNt256dvnjebuyzo52dXjAfRx2ixW5umjWSUx",
        MFCountry.KUWAIT,
        MFEnvironment.TEST,
      );

      var request = MFInitiatePaymentRequest(invoiceAmount: amount, currencyIso: MFCurrencyISO.KUWAIT_KWD);

      var response = await MFSDK.initiatePayment(request, MFLanguage.ARABIC);

      if (response.paymentMethods != null && response.paymentMethods!.isNotEmpty) {
        methods = response.paymentMethods!;
      } else {
        _errorMessage = "لا توجد وسائل دفع متاحة";
        log("تحذير: لم يتم العثور على وسائل دفع");
      }
    } catch (e) {
      _errorMessage = "فشل تحميل وسائل الدفع";
      log("خطأ في init: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Execute Payment
  // ============================================================

  Future<bool> executePayment(BuildContext context, MFPaymentMethod method, double amount) async {
    if (method.paymentMethodId == null) {
      ShowSnackBar.error("وسيلة الدفع غير صالحة");
      return false;
    }

    loading = true;
    notifyListeners();

    try {
      var request = MFExecutePaymentRequest(paymentMethodId: method.paymentMethodId!, invoiceValue: amount);

      bool paymentSuccess = false;

      await MFSDK.executePayment(request, MFLanguage.ARABIC, (invoiceId) async {
        if (invoiceId.isEmpty) {
          ShowSnackBar.error("فشل إنشاء الفاتورة");
          return;
        }

        // التحقق من حالة الدفع
        var statusRequest = MFGetPaymentStatusRequest(key: invoiceId, keyType: MFKeyType.INVOICEID);

        try {
          var response = await MFSDK.getPaymentStatus(statusRequest, MFLanguage.ARABIC);

          final status = response.invoiceStatus?.toLowerCase();

          if (status == "paid") {
            ShowSnackBar.success("تم الدفع بنجاح ✅");
            paymentSuccess = true;
          } else if (status == "pending") {
            ShowSnackBar.error("الدفع قيد المعالجة...");
          } else {
            ShowSnackBar.error("فشل الدفع: $status");
          }
        } catch (statusError) {
          log("خطأ في التحقق من حالة الدفع: $statusError");
          ShowSnackBar.error("فشل التحقق من حالة الدفع");
        }
      });

      return paymentSuccess;
    } catch (e) {
      ShowSnackBar.error("فشل الدفع");
      log("خطأ في executePayment: $e");
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // Clear Methods
  // ============================================================

  void clearMethods() {
    methods.clear();
    _errorMessage = null;
    notifyListeners();
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    methods.clear();
    super.dispose();
  }
}
