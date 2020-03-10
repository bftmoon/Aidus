class LoadingException implements Exception {
  final String msg;

  const LoadingException(this.msg);

  @override
  String toString() {
    return 'LoadingException: $msg';
  }
}

class AuthException implements Exception {
  const AuthException();
}
