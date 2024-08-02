import 'package:flutter_dotenv/flutter_dotenv.dart';

final class AuthSource {
  AuthSource._();

  final String _host =
      dotenv.get('SERVER_HOST', fallback: 'SERVER_HOST = NULL');
  final String _port =
      dotenv.get('SERVER_PORT', fallback: 'SERVER_PORT = NULL');

  String get api => '$_host:$_port';

  final String _authRoute =
      dotenv.get('AUTH_PATH', fallback: "AUTH_PATH = NULL");
  final String _authVersion = dotenv.get('AUTH_V', fallback: 'AUTH_V = NULL');

  String get _path => '$_authRoute$_authVersion';

  final String _signUpEP =
      dotenv.get('AUTH_REG_ENDPOINT', fallback: 'AUTH_REG_ENDPOINT = NULL');

  final String _signINEP =
      dotenv.get('AUTH_LOGIN_ENDPOINT', fallback: 'AUTH_LOGIN_ENDPOINT = NULL');

  String get signUpEP => '$_path$_signUpEP';

  String get signInEP => '$_path$_signINEP';

  final String _refreshTokenEP =
      dotenv.get('REFRESH_TOKEN_EP', fallback: 'REFRESH_TOKEN_EP = NULL');

  String get refreshTokenEP => '$_path$_refreshTokenEP';

  static final AuthSource _instance = AuthSource._();

  static AuthSource get instance => _instance;
}
