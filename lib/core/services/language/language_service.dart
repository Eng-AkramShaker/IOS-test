// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';

class Lang {
  static Map<String, String> _strings = {};
  static String _currentLanguage = 'en';

  static Future<void> load(String languageCode) async {
    try {
      _currentLanguage = languageCode;

      final jsonString = await rootBundle.loadString('assets/language/$languageCode.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _strings = jsonMap.map((key, value) => MapEntry(key, value.toString()));

      print('✅ Language loaded: $languageCode');
      print('✅ Strings count: ${_strings.length}');
    } catch (e) {
      print('❌ Error loading language: $e');
    }
  }

  /// ترجمة النص
  static String tr(String key) {
    final result = _strings[key] ?? key;
    return result;
  }

  /// الحصول على اللغة الحالية
  static String get currentLanguage => _currentLanguage;
}
