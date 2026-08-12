import 'package:dio/dio.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_profile/common/network/base_interceptor.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

/// A [Dio] instance with [BaseInterceptor] wired up (so status-code -> exception
/// mapping runs for real) and a [DioAdapter] that matches requests purely by
/// route + method, ignoring query parameters/body so tests don't need to
/// predict the fake ID token appended to write requests.
({Dio dio, DioAdapter adapter}) buildMockDio() {
  final dio = Dio()..options.validateStatus = (status) => true;
  final adapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher(matchMethod: true));
  dio.interceptors.add(BaseInterceptor(dio));
  return (dio: dio, adapter: adapter);
}

MockFirebaseAuth buildSignedInAuth({String uid = 'uid1', bool isAnonymous = false}) {
  return MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: uid, isAnonymous: isAnonymous));
}
