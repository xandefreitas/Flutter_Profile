import 'package:dio/dio.dart';
import 'package:flutter_profile/common/util/error_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockResponseInterceptorHandler extends Mock implements ResponseInterceptorHandler {}

void main() {
  setUpAll(() {
    registerFallbackValue(DioException(requestOptions: RequestOptions(path: '/fallback')));
  });

  group('validateException', () {
    test('DioException with a non-string error returns error.toString()', () {
      final requestOptions = RequestOptions(path: '/test');
      final exception = DioException(requestOptions: requestOptions, error: Exception('boom'));
      expect(ErrorUtil.validateException(exception), 'Exception: boom');
    });

    test('DioException with a string error returns the string unchanged', () {
      final requestOptions = RequestOptions(path: '/test');
      final exception = DioException(requestOptions: requestOptions, error: 'already a string');
      expect(ErrorUtil.validateException(exception), 'already a string');
    });

    test('non-DioException is returned unchanged', () {
      final exception = Exception('plain error');
      expect(ErrorUtil.validateException(exception), exception);
    });
  });

  group('httpException / unauthorizedException', () {
    test('httpException builds message from Map response data', () {
      final requestOptions = RequestOptions(path: '/test');
      final response = Response(requestOptions: requestOptions, statusCode: 400, data: {'Message': 'boom'});
      final result = ErrorUtil.httpException(response);
      expect(result.message, 'boom');
      expect(result.code, 400);
    });

    test('unauthorizedException builds message from String response data', () {
      final requestOptions = RequestOptions(path: '/test');
      final response = Response(requestOptions: requestOptions, statusCode: 401, data: 'unauthorized message');
      final result = ErrorUtil.unauthorizedException(response);
      expect(result.message, 'unauthorized message');
      expect(result.code, 401);
    });
  });

  group('getErrorMessage', () {
    test('returns the response data directly when it is a String', () {
      final requestOptions = RequestOptions(path: '/test');
      final response = Response(requestOptions: requestOptions, data: 'plain message');
      expect(ErrorUtil.getErrorMessage(response), 'plain message');
    });

    test("returns data['Message'] when the response data is a Map", () {
      final requestOptions = RequestOptions(path: '/test');
      final response = Response(requestOptions: requestOptions, data: {'Message': 'map message'});
      expect(ErrorUtil.getErrorMessage(response), 'map message');
    });
  });

  test('rejectResponse rejects the handler with a DioException wrapping the given exception', () {
    final requestOptions = RequestOptions(path: '/test');
    final handler = MockResponseInterceptorHandler();
    final exception = Exception('boom');

    ErrorUtil.rejectResponse(exception: exception, requestOptions: requestOptions, handler: handler);

    final captured = verify(() => handler.reject(captureAny())).captured.single as DioException;
    expect(captured.error, exception);
    expect(captured.requestOptions, requestOptions);
  });
}
