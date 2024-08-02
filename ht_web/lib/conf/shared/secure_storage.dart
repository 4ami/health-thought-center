import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class SecureStorage {
  SecureStorage._();
  static final SecureStorage _instance = SecureStorage._();

  static SecureStorage get instance => _instance;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> write({required String token, required String refToken}) async {
    try {
      log('TOKEN: $token');
      await _storage.write(key: 'token', value: token);
      log('REFRESH TOKEN: $refToken');
      await _storage.write(key: 'refToken', value: refToken);
    } catch (e) {
      log('[SecureStorage - Write] Error $e');
    }
  }

  Future<Map<String, String>> read() async {
    try {
      final String? token = await _storage.read(key: 'token');
      final String? refToken = await _storage.read(key: 'refToken');

      return {'token': token ?? '', 'refToken': refToken ?? ''};
    } catch (e) {
      log('[SecureStorage - Read] Error $e');
      return {'token': '', 'refToken': ''};
    }
  }

  Future<bool> check() async {
    bool isTokenExist = await _storage.containsKey(key: 'token');
    bool isRefreshTokenExist = await _storage.containsKey(key: 'refToken');
    return (isTokenExist && isRefreshTokenExist);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
