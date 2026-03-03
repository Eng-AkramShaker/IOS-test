// ignore_for_file: non_constant_identifier_names, file_names

import 'package:buynuk/presentation/flash_sales/domain/models/flashSales_model.dart';
import 'package:buynuk/presentation/flash_sales/domain/services/flashSales_service.dart';
import 'package:flutter/material.dart';

class FlashSalesProvider extends ChangeNotifier {
  final FlashSalesService flashSalesService;
  FlashSalesProvider({required this.flashSalesService});

  // ── State ──────────────────────────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  FlashSalesModel? _flashSalesModel;
  FlashSalesModel? get flashSalesModel => _flashSalesModel;

  // ── getFlashSales ──────────────────────────────────────────────
  Future<void> getFlashSales() async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      _flashSalesModel = await flashSalesService.getFlashSales();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('FlashSalesProvider Error: $e');
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  // ── Dispose guard ──────────────────────────────────────────────
  bool _disposed = false;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
