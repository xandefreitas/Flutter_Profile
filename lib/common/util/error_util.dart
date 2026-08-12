import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../network/http_exception.dart';
import '../network/unauthorized_exception.dart';

abstract class ErrorUtil {
  static dynamic validateException(dynamic e) {
    debugPrint(e.toString());
    if (e is DioException) {
      return e.error is! String ? e.error.toString() : e.error;
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

  static UnauthorizedException unauthorizedException(
    Response<dynamic> response,
  ) {
    return UnauthorizedException(
      message: getErrorMessage(response),
      code: response.statusCode!,
    );
  }

  static void rejectResponse({
    required Exception exception,
    required RequestOptions requestOptions,
    required ResponseInterceptorHandler handler,
  }) {
    return handler.reject(
      DioException(requestOptions: requestOptions, error: exception),
    );
  }

  static dynamic getErrorMessage(Response response) =>
      response.data is String
          ? response.data
          : (response.data as Map)['Message'];
}
