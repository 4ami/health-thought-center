import 'dart:convert';

final class AuthRequest {
  AuthRequest._();

  static final AuthRequest _instance = AuthRequest._();

  static AuthRequest get instance => _instance;

  String register(String fname, String email, String pass) => jsonEncode({
        "full_name": fname,
        "email": email,
        "password": pass,
      });

  String login(String email, String pass) => jsonEncode({
        "email": email,
        "password": pass,
      });
}
