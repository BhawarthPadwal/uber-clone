import '../storage/local_storage_service.dart';
import '../utils/api/api_manager.dart';
import '../utils/api/api_req_endpoints.dart';
import '../utils/logger/app_logger.dart';

class ApiService {

  static Future<bool> refreshToken() async {
    final result = await ApiManager.getWithHeader(ApiReqEndpoints.getRefreshToken());
    AppLogger.d(result);
    if (result['status'] == 200) {
      LocalStorageService.saveToken(result['data']['token']);
      return true;
    }
    return false;
  }
}