import 'dart:io';

import 'package:dio/dio.dart';

import '../network/http_exception.dart';
import '../network/unauthorized_exception.dart';

abstract class ErrorUtil {
  static validateException(dynamic e) {
    if (e is DioError) {
      if (e.error is! String) {
        return e.error is SocketException ? e.error.osError.message : e.error.toString();
      }
    } else {
      return e;
    }
  }

  static HttpException httpException(Response<dynamic> response) {
    return HttpException(
      message: getErrorMessage(response),
      code: response.statusCode!,
    );
  }

  static UnauthorizedException unauthorizedException(Response<dynamic> response) {
    return UnauthorizedException(
      message: getErrorMessage(response),
      code: response.statusCode!,
    );
  }

  static rejectResponse({
    required Exception exception,
    required RequestOptions requestOptions,
    required ResponseInterceptorHandler handler,
  }) {
    return handler.reject(
      DioError(
        requestOptions: requestOptions,
        error: exception,
      ),
    );
  }

  static getErrorMessage(Response response) => response.data is String ? response.data : response.data["Message"];
}
