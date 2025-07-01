import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiReqEndpoints {
  ApiReqEndpoints._();

  static final String BASE_URL = dotenv.env['BASE_URL']!;
  static const _usersPath = '/users';
  static const _captainsPath = '/captains';
  static const _mapsPath = '/maps';
  static const _ridesPath = '/rides';

  static String getRefreshToken() {
    return '$BASE_URL$_usersPath/verify-token';
  }

  static String getUserLogin() {
    return '$BASE_URL$_usersPath/login';
  }

  static String getUserRegister() {
    return '$BASE_URL$_usersPath/register';
  }

  static String getCaptainLogin() {
    return '$BASE_URL$_captainsPath/login';
  }

  static String getCaptainSignup() {
    return '$BASE_URL$_captainsPath/register';
  }

  static String getMapSuggestion(String input) {
    return '$BASE_URL$_mapsPath/get-suggestions?input=$input';
  }

  static String getFare(String pickup, String destination) {
    return '$BASE_URL$_ridesPath/fare?pickup=$pickup&destination=$destination';
  }

  static String postRideCreated() {
    return '$BASE_URL$_ridesPath/create';
  }
}


