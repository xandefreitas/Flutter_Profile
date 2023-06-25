import 'package:dio/dio.dart';

import '../../core/core.dart';
import 'base_interceptor.dart';

abstract class DioBase {
  static getDio({
    List<Interceptor>? interceptors,
    int timeout = 50000,
  }) {
    Dio dio = Dio()
      ..options.validateStatus = (status) {
        return true;
      }
      ..interceptors.addAll(interceptors ?? [])
      ..options.baseUrl = Consts.databaseUrl
      ..options.connectTimeout = Duration(milliseconds: timeout);

    dio.interceptors.add(BaseInterceptor(dio));
    return dio;
  }
}
