import 'dart:convert';

import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';
import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic>? body,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      final parsedBody = jsonDecode(response.body);

      final result = {'status': response.statusCode, 'data': parsedBody};

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.d(result);
      } else {
        AppLogger.e(result);
      }

      return result;
    } catch (e) {
      AppLogger.e(e);
      throw Exception(e.toString());
    }
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse(endpoint));
      final parsedBody = jsonDecode(response.body);
      final result = {'status': response.statusCode, 'data': parsedBody};
      if (response.statusCode == 200) {
        AppLogger.d(result);
      } else {
        AppLogger.e(result);
      }
      return result;
    } catch (e) {
      AppLogger.e(e);
      throw Exception(e.toString());
    }
  }

  static Future<Map<String, dynamic>> getWithHeader(String endpoint) async {
    try {
      final token = LocalStorageService.getToken();
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {'Authorization': 'Bearer $token'},
      );
      final parsedBody = jsonDecode(response.body);
      final result = {'status': response.statusCode, 'data': parsedBody};
      if (response.statusCode == 200) {
        AppLogger.d(result);
      } else {
        AppLogger.e(result);
      }
      return result;
    } catch (e) {
      AppLogger.e(e);
      throw Exception(e.toString());
    }
  }

  static Future<Map<String, dynamic>> postWithHeader(
    String endpoint,
    Map<String, dynamic>? body,
  ) async {
    try {
      final token = LocalStorageService.getToken();
      final response = await http.post(
        Uri.parse(endpoint),
        body: jsonEncode(body),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final parsedBody = jsonDecode(response.body);
      final result = {'status': response.statusCode, 'data': parsedBody};
      if (response.statusCode == 201) {
        AppLogger.d(result);
      } else {
        AppLogger.e(result);
      }
      return result;
    } catch (e) {
      AppLogger.e(e);
      throw Exception(e.toString());
    }
  }
}
