// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:buynuk/core/services/api_service.dart';
import 'package:buynuk/presentation/orders/domain/models/orders_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

class OrdersRepository {
  final ApiClient apiClient;

  OrdersRepository({required this.apiClient});

  // -----------------------------------------------------------------------
  /// Orders
  // -----------------------------------------------------------------------

  Future<OrdersModel> getOrders() async {
    final http.Response response = await apiClient.getData(AppConstants.ordersUri);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return OrdersModel.fromJson(json);
  }
}
