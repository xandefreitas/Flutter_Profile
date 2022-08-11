class HttpException implements Exception {
  final dynamic message;
  final int code;

  HttpException({required this.message, required this.code});
}
