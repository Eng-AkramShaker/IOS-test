import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  PrefsService._();

  static SharedPreferences? _prefs;

  // -----------------------------------------------------------------------
  /// Initialize SharedPreferences (يُستدعى مرة واحدة عند بدء التطبيق)
  // -----------------------------------------------------------------------

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // -----------------------------------------------------------------------
  /// Get Instance (للتأكد من التهيئة)
  // -----------------------------------------------------------------------

  static Future<SharedPreferences> _getInstance() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // -----------------------------------------------------------------------
  /// String Operations
  // -----------------------------------------------------------------------

  static Future<String?> getString(String key) async {
    final prefs = await _getInstance();
    return prefs.getString(key);
  }

  static Future<bool> setString(String key, String value) async {
    final prefs = await _getInstance();
    return await prefs.setString(key, value);
  }

  // -----------------------------------------------------------------------
  /// Int Operations
  // -----------------------------------------------------------------------

  static Future<int?> getInt(String key) async {
    final prefs = await _getInstance();
    return prefs.getInt(key);
  }

  static Future<bool> setInt(String key, int value) async {
    final prefs = await _getInstance();
    return await prefs.setInt(key, value);
  }

  // -----------------------------------------------------------------------
  /// Bool Operations
  // -----------------------------------------------------------------------

  static Future<bool?> getBool(String key) async {
    final prefs = await _getInstance();
    return prefs.getBool(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    final prefs = await _getInstance();
    return await prefs.setBool(key, value);
  }

  // -----------------------------------------------------------------------
  /// Double Operations
  // -----------------------------------------------------------------------

  static Future<double?> getDouble(String key) async {
    final prefs = await _getInstance();
    return prefs.getDouble(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    final prefs = await _getInstance();
    return await prefs.setDouble(key, value);
  }

  // -----------------------------------------------------------------------
  /// List<String> Operations
  // -----------------------------------------------------------------------

  static Future<List<String>?> getStringList(String key) async {
    final prefs = await _getInstance();
    return prefs.getStringList(key);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _getInstance();
    return await prefs.setStringList(key, value);
  }

  // -----------------------------------------------------------------------
  /// Check if key exists
  // -----------------------------------------------------------------------

  static Future<bool> containsKey(String key) async {
    final prefs = await _getInstance();
    return prefs.containsKey(key);
  }

  // -----------------------------------------------------------------------
  /// Get all keys
  // -----------------------------------------------------------------------

  static Future<Set<String>> getAllKeys() async {
    final prefs = await _getInstance();
    return prefs.getKeys();
  }

  // -----------------------------------------------------------------------
  /// Remove single key
  // -----------------------------------------------------------------------

  static Future<bool> remove(String key) async {
    final prefs = await _getInstance();
    return await prefs.remove(key);
  }

  // -----------------------------------------------------------------------
  /// Remove multiple keys
  // -----------------------------------------------------------------------

  static Future<void> removeMultiple(List<String> keys) async {
    final prefs = await _getInstance();
    for (String key in keys) {
      await prefs.remove(key);
    }
  }

  // -----------------------------------------------------------------------
  /// Clear all data
  // -----------------------------------------------------------------------

  static Future<bool> clear() async {
    final prefs = await _getInstance();
    return await prefs.clear();
  }

  // -----------------------------------------------------------------------
  /// Clear all except specific keys
  // -----------------------------------------------------------------------

  static Future<void> clearExcept(List<String> keysToKeep) async {
    final prefs = await _getInstance();
    final allKeys = prefs.getKeys();

    for (String key in allKeys) {
      if (!keysToKeep.contains(key)) {
        await prefs.remove(key);
      }
    }
  }

  // -----------------------------------------------------------------------
  /// Reload (تحديث البيانات من القرص)
  // -----------------------------------------------------------------------

  static Future<void> reload() async {
    final prefs = await _getInstance();
    await prefs.reload();
  }

  // -----------------------------------------------------------------------
  /// Helper: Save JSON as String
  // -----------------------------------------------------------------------

  static Future<bool> setJson(String key, Map<String, dynamic> json) async {
    final prefs = await _getInstance();
    final String jsonString = jsonEncode(json);
    return await prefs.setString(key, jsonString);
  }

  // -----------------------------------------------------------------------
  /// Helper: Get JSON from String
  // -----------------------------------------------------------------------

  static Future<Map<String, dynamic>?> getJson(String key) async {
    final prefs = await _getInstance();
    final String? jsonString = prefs.getString(key);

    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Error decoding JSON for key '$key': $e");
      return null;
    }
  }
}
