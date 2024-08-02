interface class Register {
  Future<Map<String, String>> register({
    required String fullName,
    required email,
    required password,
  }) {
    throw UnimplementedError();
  }
}
