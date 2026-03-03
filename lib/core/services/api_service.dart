// ignore_for_file: depend_on_referenced_packages, unnecessary_import

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:buynuk/core/constants/app_constants.dart';
import 'package:buynuk/core/services/prefe_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ApiClient {
  final int timeout = 40;

  // -----------------------------------------------------------------------
  /// Get Headers with Token
  // -----------------------------------------------------------------------

  Future<Map<String, String>> _headers() async {
    final token = await PrefsService.getString("api_token");

    // Debug: طباعة التوكن للتأكد من وجوده
    if (kDebugMode) {
      if (token != null && token.isNotEmpty) {
        log("🔑 Token found: ${token.substring(0, 20)}...");
      } else {
        log("⚠️ No token found in SharedPreferences");
      }
    }

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Connection": "keep-alive",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  // -----------------------------------------------------------------------
  /// Handle 401 Unauthorized
  // -----------------------------------------------------------------------

  Future<void> _handle401() async {
    log("⚠️ 401 UNAUTHORIZED - Clearing token");
    await PrefsService.remove("api_token");
    await PrefsService.remove("user_data");
    await PrefsService.remove("email");
    await PrefsService.remove("password");
  }

  // -----------------------------------------------------------------------
  /// Check Response Status
  // -----------------------------------------------------------------------

  Future<http.Response> _checkResponse(http.Response response) async {
    if (response.statusCode == 401) {
      await _handle401();

      // إرجاع response موحد مع معلومات الخطأ
      final Map<String, dynamic> errorBody = {
        "success": false,
        "error": "Invalid API token. Please login again.",
        "error_code": "INVALID_TOKEN",
        "status_code": 401,
      };
      return http.Response(jsonEncode(errorBody), 401);
    }
    return response;
  }

  // -----------------------------------------------------------------------
  /// GET
  // -----------------------------------------------------------------------

  Future<http.Response> getData(String uri) async {
    try {
      final headers = await _headers();
      final url = Uri.parse(AppConstants.baseUrl + uri);

      log("GET:    $url");
      if (kDebugMode) {
        log("HEADERS: ${headers.keys.join(', ')}");
      }

      final response = await http.get(url, headers: headers).timeout(Duration(seconds: timeout));

      _logResponse(response);
      return await _checkResponse(response);
    } catch (e) {
      log("GET ERROR: $e");
      return http.Response(
        jsonEncode({"success": false, "error": "No internet connection", "error_code": "NO_INTERNET"}),
        0,
      );
    }
  }

  // -----------------------------------------------------------------------
  /// POST
  // -----------------------------------------------------------------------

  Future<http.Response> postData(String uri, dynamic body, {bool handleError = true}) async {
    try {
      final headers = await _headers();
      final url = Uri.parse(AppConstants.baseUrl + uri);

      log("POST: $url");
      log("BODY: ${jsonEncode(body)}");
      if (kDebugMode) {
        log("HEADERS: ${headers.keys.join(', ')}");
      }

      final response = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(Duration(seconds: timeout));

      _logResponse(response);
      return await _checkResponse(response);
    } catch (e) {
      log("POST ERROR: $e");
      return http.Response(
        jsonEncode({"success": false, "error": "No internet connection", "error_code": "NO_INTERNET"}),
        0,
      );
    }
  }

  // -----------------------------------------------------------------------
  /// PUT
  // -----------------------------------------------------------------------

  Future<http.Response> putData(String uri, dynamic body) async {
    try {
      final headers = await _headers();
      final url = Uri.parse(AppConstants.baseUrl + uri);

      log("PUT:  $url");
      log("BODY: ${jsonEncode(body)}");

      final response = await http
          .put(url, headers: headers, body: jsonEncode(body))
          .timeout(Duration(seconds: timeout));

      _logResponse(response);
      return await _checkResponse(response);
    } catch (e) {
      log("PUT ERROR: $e");
      return http.Response(
        jsonEncode({"success": false, "error": "No internet connection", "error_code": "NO_INTERNET"}),
        0,
      );
    }
  }

  // -----------------------------------------------------------------------
  /// DELETE
  // -----------------------------------------------------------------------

  Future<http.Response> deleteData(String uri) async {
    try {
      final headers = await _headers();
      final url = Uri.parse(AppConstants.baseUrl + uri);

      log("DELETE: $url");

      final response = await http.delete(url, headers: headers).timeout(Duration(seconds: timeout));

      _logResponse(response);
      return await _checkResponse(response);
    } catch (e) {
      log("DELETE ERROR: $e");
      return http.Response(
        jsonEncode({"success": false, "error": "No internet connection", "error_code": "NO_INTERNET"}),
        0,
      );
    }
  }

  // -----------------------------------------------------------------------
  /// MULTIPART
  // -----------------------------------------------------------------------

  Future<http.Response> multipart(String uri, Map<String, String> body, List<MultipartBody> files) async {
    try {
      final headers = await _headers();
      final url = Uri.parse(AppConstants.baseUrl + uri);

      log("MULTIPART: $url");

      final request = http.MultipartRequest("POST", url);
      request.headers.addAll(headers);
      request.fields.addAll(body);

      for (var file in files) {
        if (file.file != null) {
          final Uint8List bytes = await file.file!.readAsBytes();

          request.files.add(
            http.MultipartFile(
              file.key,
              file.file!.readAsBytes().asStream(),
              bytes.length,
              filename: file.file!.name,
            ),
          );
        }
      }

      final response = await http.Response.fromStream(
        await request.send().timeout(Duration(seconds: timeout)),
      );

      _logResponse(response);
      return await _checkResponse(response);
    } catch (e) {
      log("MULTIPART ERROR: $e");
      return http.Response(
        jsonEncode({"success": false, "error": "No internet connection", "error_code": "NO_INTERNET"}),
        0,
      );
    }
  }

  // -----------------------------------------------------------------------
  /// Log Response
  // -----------------------------------------------------------------------

  void _logResponse(http.Response response) {
    if (kDebugMode) {
      log("STATUS: ${response.statusCode}");
      debugPrint("\x1B[32m   BODY:  ${response.body}    \x1B[0m");
    }
  }
}

// -----------------------------------------------------------------------
/// Helper class for multipart file uploads
// -----------------------------------------------------------------------

class MultipartBody {
  final String key;
  final XFile? file;

  MultipartBody(this.key, this.file);
}
