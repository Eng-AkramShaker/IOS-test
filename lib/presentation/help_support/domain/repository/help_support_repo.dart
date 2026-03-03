// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:buynuk/core/services/api_service.dart';
import 'package:buynuk/presentation/help_support/domain/models/Legal_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

class HelpSupportRepository {
  final ApiClient apiClient;

  HelpSupportRepository({required this.apiClient});

  // -----------------------------------------------------------------------
  ///  Privacy Policy
  // -----------------------------------------------------------------------

  Future<LegalModel> getPrivacyPolicy() async {
    final http.Response response = await apiClient.getData(AppConstants.privacyPolicyUri);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return LegalModel.fromJson(json);
  }

  // -----------------------------------------------------------------------
  ///  Terms
  // -----------------------------------------------------------------------

  Future<LegalModel> getTerms() async {
    final http.Response response = await apiClient.getData(AppConstants.termsUri);

    final Map<String, dynamic> json = jsonDecode(response.body);
    return LegalModel.fromJson(json);
  }
}
