class UnauthorizedException implements Exception {
  final dynamic message;
  final int code;

  UnauthorizedException({required this.message, required this.code});
}
