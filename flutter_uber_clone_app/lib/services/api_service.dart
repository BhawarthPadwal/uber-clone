import '../storage/local_storage_service.dart';
import '../utils/api/api_manager.dart';
import '../utils/api/api_req_endpoints.dart';
import '../utils/logger/app_logger.dart';

class ApiService {
  static Future<bool> refreshToken() async {
    final result = await ApiManager.getWithHeader(
      ApiReqEndpoints.getRefreshToken(),
    );
    AppLogger.d(result);
    if (result['status'] == 200) {
      LocalStorageService.saveToken(result['data']['token']);
      return true;
    }
    return false;
  }

  static Future<String> getRoutes(String origin, String destination) async {
    try {
      final result = await ApiManager.get(
        ApiReqEndpoints.getRoutes(origin, destination),
      );
      AppLogger.d('Raw API result: $result');
      if (result['status'] == 200 || result['status'] == 'OK') {
        final data = result['data'];
        final String polyline = result['data']['data']['polyline'];
        AppLogger.d('Route data: $data');
        return polyline;
      } else {
        final message = result['data']?['message'] ?? 'Unknown error occurred';
        AppLogger.e('API Error: $message');
        throw Exception(message);
      }
    } catch (e) {
      AppLogger.e('Exception in getRoutes: $e');
      rethrow; // Let caller handle this
    }
  }
}
