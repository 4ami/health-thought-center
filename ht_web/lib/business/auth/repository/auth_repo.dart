import 'dart:convert';
import 'dart:developer';
import 'package:ht_web/business/auth/model/auth_response.dart';
import 'package:ht_web/business/auth/repository/auth_exception.dart';
import 'package:ht_web/data/model/auth_request.dart';
import 'package:http/http.dart' as http;
import 'package:ht_web/business/auth/usecase/login.dart';
import 'package:ht_web/business/auth/usecase/refresh.dart';
import 'package:ht_web/business/auth/usecase/register.dart';
import 'package:ht_web/data/source/auth.dart';

class AuthRepo implements Login, Register, RefreshToken {
  AuthRepo._();

  static final AuthRepo _instance = AuthRepo._();
  static AuthRepo get instance => _instance;

  Map<String, String> get _headers => {
        'content-type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      };

  @override
  Future<Map<String, String>> login(
      {required String email, required pass}) async {
    try {
      Uri uri = Uri.https(
        AuthSource.instance.api,
        AuthSource.instance.signInEP,
      );
      http.Response response = await http
          .post(
            uri,
            headers: _headers,
            body: AuthRequest.instance.login(email, pass),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw const AuthenticationException(reason: 'Connection Lost'),
          );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode != 202) {
        throw AuthenticationException(reason: body['message']);
      }

      return AuthResponse.instance.login(body);
    } catch (e) {
      log("[AuthRepo Error]: LOGIN $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, String>> register({
    required String fullName,
    required email,
    required password,
  }) async {
    try {
      Uri uri = Uri.https(
        AuthSource.instance.api,
        AuthSource.instance.signUpEP,
      );

      http.Response response = await http
          .post(
            uri,
            headers: _headers,
            body: AuthRequest.instance.register(fullName, email, password),
          )
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw const AuthenticationException(
                  reason: 'Connection Lost'));
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw AuthenticationException(reason: body['message']);
      }

      return AuthResponse.instance.register(body);
    } catch (e) {
      log("[AuthRepo Error]: REGISTER $e");
      rethrow;
    }
  }

  @override
  Future<String> refreshToken({required String refreshToken}) async {
    try {
      Uri uri =
          Uri.https(AuthSource.instance.api, AuthSource.instance.refreshTokenEP);

      http.Response response = await http
          .post(
            uri,
            headers: _headers,
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () =>
                throw const AuthenticationException(reason: 'Connection Lost'),
          );

      final Map<String, dynamic> body = jsonDecode(response.body);
      if (response.statusCode != 201) {
        throw const AuthenticationException(reason: 'Invalid Refresh Token');
      }

      return body['token'];
    } catch (e) {
      log("[AuthRepo Error]: REFRESH TOKEN $e");
      rethrow;
    }
  }
}
