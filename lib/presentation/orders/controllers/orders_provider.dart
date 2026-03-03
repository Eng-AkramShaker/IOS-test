// ignore_for_file: non_constant_identifier_names

import 'package:buynuk/presentation/orders/domain/models/orders_model.dart';
import 'package:buynuk/presentation/orders/domain/services/orders_service.dart';
import 'package:flutter/material.dart';

class OrdersProvider extends ChangeNotifier {
  final OrdersService ordersService;
  OrdersProvider({required this.ordersService});

  // -----------------------------------------------------------------------
  /// State
  // -----------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  OrdersModel? _ordersModel;
  OrdersModel? get ordersModel => _ordersModel;

  // -----------------------------------------------------------------------
  /// getOrders
  // -----------------------------------------------------------------------

  Future<void> getOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notify();

    try {
      _ordersModel = await ordersService.getOrders();
      notify();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      notify();
    }
  }

  //  التحقق قبل الإشعار -------------------------------------------

  bool _disposed = false;
  void notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
