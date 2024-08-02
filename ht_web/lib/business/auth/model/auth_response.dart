final class AuthResponse {
  AuthResponse._();

  static final AuthResponse _instance = AuthResponse._();
  static AuthResponse get instance => _instance;

  Map<String, String> register(Map<String, dynamic> res) => {
    "full_name": res['full_name'].toString(),
    "email": res['email'].toString(),
    "role": res['role'].toString()
  };
  Map<String, String> login(Map<String, dynamic> res) => {
    "token": res['token'].toString(),
    "refreshToken": res['refreshToken'].toString(),
  };
}
