final class AuthenticationException implements Exception {
  final String reason;
  const AuthenticationException({required this.reason});
}
