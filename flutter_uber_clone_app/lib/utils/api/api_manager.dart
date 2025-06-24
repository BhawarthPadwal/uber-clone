import 'dart:convert';

import 'package:flutter_uber_clone_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;
class ApiManager {

  ApiManager._();

  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(Uri.parse(endpoint), body: body);
      AppLogger.d(response);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      AppLogger.e(e);
      throw Exception(e.toString());
    }
  }
}