sealed class AuthEvent {
  final String? message;
  const AuthEvent({this.message});
}

final class AuthInintEvent extends AuthEvent {
  const AuthInintEvent();
}

final class AuthPending extends AuthEvent {
  const AuthPending();
}

final class AuthRegister extends AuthEvent {
  final String fname, email, pass;
  const AuthRegister({
    required this.fname,
    required this.email,
    required this.pass,
  });
}

final class AuthLogin extends AuthEvent {
  final String email, pass;
  const AuthLogin({required this.email, required this.pass});
}

final class AuthLoginSuccess extends AuthEvent {
  const AuthLoginSuccess();
}

final class AuthRegisterSuccess extends AuthEvent {
  const AuthRegisterSuccess();
}

final class TokenExpiredOrNull extends AuthEvent {
  const TokenExpiredOrNull();
}

final class RefreshToken extends AuthEvent {
  const RefreshToken();
}

final class SignOut extends AuthEvent {
  const SignOut();
}

final class RefreshTokenSuccess extends AuthEvent {
  const RefreshTokenSuccess();
}

final class AuthException extends AuthEvent {
  const AuthException({required super.message});
}