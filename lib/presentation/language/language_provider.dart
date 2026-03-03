import 'package:buynuk/core/services/language/language_service.dart';
import 'package:buynuk/core/services/prefe_service.dart';
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  LanguageProvider();

  Future<void> loadSavedLanguage() async {
    final code = await PrefsService.getString('languageCode');
    if (code != null) {
      _locale = Locale(code);
      await Lang.load(code);
    } else {
      await Lang.load('en');
    }
    notifyListeners();
  }

  Future<void> changeLanguage(String code) async {
    _locale = Locale(code);
    await Lang.load(code);
    await PrefsService.setString('languageCode', code);
    notifyListeners();
  }
}
