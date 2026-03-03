// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:buynuk/core/services/api_service.dart';
import 'package:buynuk/presentation/newArrival/domain/models/newArrival_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

class NewArrivalRepository {
  final ApiClient apiClient;

  NewArrivalRepository({required this.apiClient});

  // -----------------------------------------------------------------------
  /// NewArrival
  // -----------------------------------------------------------------------

  Future<NewArrivalModel> geNewArrival() async {
    final http.Response response = await apiClient.getData(AppConstants.newArrivalsUri);

    final Map<String, dynamic> json = jsonDecode(response.body);

    return NewArrivalModel.fromJson(json);
  }
}
