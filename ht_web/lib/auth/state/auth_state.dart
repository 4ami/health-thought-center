import 'package:ht_web/auth/event/auth_event.dart';

final class AuthState {
  final String fname, email, role, token, refToken;
  final AuthEvent event;
  const AuthState({
    this.fname = '',
    this.email = '',
    this.role = '',
    this.refToken = '',
    this.token = '',
    this.event = const AuthInintEvent(),
  });

  AuthState clear() => const AuthState();

  AuthState copyWith({
    String? fname,
    String? email,
    String? role,
    String? token,
    String? refToken,
    AuthEvent? event,
  }) {
    return AuthState(
      fname: fname ?? this.fname,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      refToken: refToken ?? this.refToken,
      event: event ?? this.event,
    );
  }
}
