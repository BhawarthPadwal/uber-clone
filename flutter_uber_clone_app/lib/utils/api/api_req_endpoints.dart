import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiReqEndpoints {

  ApiReqEndpoints._();

  static final String BASE_URL = dotenv.env['BASE_URL']!;
  static const _usersPath = '/users';
  static const _captainsPath = '/captains';

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
}