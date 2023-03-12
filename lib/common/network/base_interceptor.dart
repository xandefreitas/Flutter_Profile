import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../util/error_util.dart';

class BaseInterceptor implements InterceptorsWrapper {
  final Dio dio;

  BaseInterceptor(this.dio);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 401) {
      ErrorUtil.rejectResponse(
        exception: ErrorUtil.unauthorizedException(response),
        requestOptions: response.requestOptions,
        handler: handler,
      );
    }
    if (response.statusCode! >= 400) {
      ErrorUtil.rejectResponse(
        exception: ErrorUtil.httpException(response),
        requestOptions: response.requestOptions,
        handler: handler,
      );
    }

    return handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint(err.message);
    debugPrint(err.response.toString());

    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }
}
