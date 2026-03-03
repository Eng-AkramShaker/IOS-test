// ignore_for_file: non_constant_identifier_names

import 'package:buynuk/presentation/newArrival/domain/models/newArrival_model.dart';
import 'package:buynuk/presentation/newArrival/domain/services/newArrival_service.dart';
import 'package:flutter/material.dart';

class NewArrivalProvider extends ChangeNotifier {
  final NewArrivalService newArrivalService;

  NewArrivalProvider({required this.newArrivalService});

  // -----------------------------------------------------------------------
  /// State
  // -----------------------------------------------------------------------

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  NewArrivalModel? _newArrivalModel;
  NewArrivalModel? get newArrivalModel => _newArrivalModel;

  // -----------------------------------------------------------------------
  /// getBanners
  // -----------------------------------------------------------------------

  Future<void> geNewArrival() async {
    _isLoading = true;
    _errorMessage = null;
    _notify();

    try {
      _newArrivalModel = await newArrivalService.geNewArrival();
      _notify();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error: $e');
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
