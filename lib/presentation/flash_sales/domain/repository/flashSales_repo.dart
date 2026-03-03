// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:buynuk/core/services/api_service.dart';
import 'package:buynuk/presentation/flash_sales/domain/models/flashSales_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

class FlashSalesRepository {
  final ApiClient apiClient;

  FlashSalesRepository({required this.apiClient});

  // -----------------------------------------------------------------------
  /// Banners
  // -----------------------------------------------------------------------

  Future<FlashSalesModel> getFlashSales() async {
    final http.Response response = await apiClient.getData(AppConstants.flashSalesUri);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return FlashSalesModel.fromJson(json);
  }
}
