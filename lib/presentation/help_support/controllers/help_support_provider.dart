// ignore_for_file: non_constant_identifier_names

import 'package:buynuk/presentation/help_support/domain/services/help_support_service.dart';
import 'package:buynuk/presentation/help_support/domain/models/Legal_model.dart';
import 'package:flutter/material.dart';

class HelpSupportProvider extends ChangeNotifier {
  HelpSupportService helpSupportService;

  HelpSupportProvider({required this.helpSupportService});
  // -----------------------------------------------------------------------
  /// State
  // -----------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LegalModel? _legalModel;
  LegalModel? get legalModel => _legalModel;

  // -----------------------------------------------------------------------
  ///
  // -----------------------------------------------------------------------

  Future<void> loadLegal(String type) async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      if (type == "privacy") {
        _legalModel = await helpSupportService.getPrivacyPolicy();
      } else if (type == "terms") {
        _legalModel = await helpSupportService.getAllTerms();
      }

      _notify();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      _notify();
    }
  }

  //  التحقق قبل الإشعار -------------------------------------------

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
