import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_profile/common/api/certificates_webclient.dart';
import 'package:flutter_profile/common/bloc/certificatesBloc/certificates_bloc.dart';
import 'package:flutter_profile/common/bloc/certificatesBloc/certificates_event.dart';
import 'package:flutter_profile/common/bloc/certificatesBloc/certificates_state.dart';
import 'package:flutter_profile/common/models/certificate.dart';
import 'package:flutter_profile/common/util/connectivity_util.dart';
import 'package:flutter_profile/common/util/error_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCertificatesWebClient extends Mock implements CertificatesWebClient {}

void main() {
  late MockCertificatesWebClient webClient;
  final certificate = Certificate(id: '1', course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1');

  // `Stream.value(...)` delivers on a later microtask, which would race
  // against blocTest's synchronous `build()`. A sync broadcast controller
  // delivers `add()` to the already-attached listener immediately, so
  // ConnectivityUtil.isConnected reflects it before `build()` returns.
  ConnectivityUtil connectivityWith(bool connected) {
    final controller = StreamController<bool>.broadcast(sync: true);
    final connectivity = ConnectivityUtil(connectedStream: controller.stream);
    controller.add(connected);
    return connectivity;
  }

  ConnectivityUtil onlineConnectivity() => connectivityWith(true);
  ConnectivityUtil offlineConnectivity() => connectivityWith(false);

  setUpAll(() {
    registerFallbackValue(certificate);
  });

  setUp(() {
    webClient = MockCertificatesWebClient();
  });

  blocTest<CertificatesBloc, CertificatesState>(
    'emits [Fetching, Fetched] for the first value of the certificates stream',
    build: () {
      when(() => webClient.watchCertificates()).thenAnswer((_) => Stream.value([certificate]));
      return CertificatesBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(CertificatesFetchEvent()),
    expect: () => [CertificatesFetchingState(), CertificatesFetchedState(certificates: [certificate])],
  );

  blocTest<CertificatesBloc, CertificatesState>(
    'emits a new Fetched state for every value the certificates stream produces afterwards',
    build: () {
      final controller = StreamController<List<Certificate>>();
      addTearDown(controller.close);
      when(() => webClient.watchCertificates()).thenAnswer((_) => controller.stream);
      controller.add([certificate]);
      final second = Certificate(id: '2', course: 'Other', institution: 'Institution 2', description: 'Desc 2', credentialUrl: 'url2', date: '2023', duration: '2');
      Future<void>.delayed(Duration.zero, () => controller.add([certificate, second]));
      return CertificatesBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(CertificatesFetchEvent()),
    expect:
        () => [
          CertificatesFetchingState(),
          CertificatesFetchedState(certificates: [certificate]),
          CertificatesFetchedState(
            certificates: [certificate, Certificate(id: '2', course: 'Other', institution: 'Institution 2', description: 'Desc 2', credentialUrl: 'url2', date: '2023', duration: '2')],
          ),
        ],
  );

  blocTest<CertificatesBloc, CertificatesState>(
    'ignores a second CertificatesFetchEvent while already subscribed, instead of opening a duplicate subscription',
    build: () {
      when(() => webClient.watchCertificates()).thenAnswer((_) => Stream.value([certificate]));
      return CertificatesBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc..add(CertificatesFetchEvent())..add(CertificatesFetchEvent()),
    expect: () => [CertificatesFetchingState(), CertificatesFetchedState(certificates: [certificate])],
    verify: (_) {
      verify(() => webClient.watchCertificates()).called(1);
    },
  );

  blocTest<CertificatesBloc, CertificatesState>(
    'emits [Fetching, Error] when the certificates stream errors',
    build: () {
      when(() => webClient.watchCertificates()).thenAnswer((_) => Stream.error(Exception('boom')));
      return CertificatesBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(CertificatesFetchEvent()),
    expect: () => [CertificatesFetchingState(), isA<CertificatesErrorState>().having((s) => s.exception.toString(), 'exception', 'Exception: boom')],
  );

  blocTest<CertificatesBloc, CertificatesState>(
    'emits [Adding, Added] when addCertificate succeeds',
    build: () {
      when(() => webClient.addCertificate(any())).thenAnswer((_) async => certificate);
      return CertificatesBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(CertificatesAddEvent(certificate: certificate)),
    expect: () => [CertificatesAddingState(), CertificatesAddedState(certificate: certificate)],
    verify: (_) {
      verify(() => webClient.addCertificate(certificate)).called(1);
    },
  );

  blocTest<CertificatesBloc, CertificatesState>(
    'emits [Updating, Updated] when updateCertificate succeeds',
    build: () {
      when(() => webClient.updateCertificate(any())).thenAnswer((_) async => certificate);
      return CertificatesBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(CertificatesUpdateEvent(certificate: certificate)),
    expect: () => [CertificatesUpdatingState(), CertificatesUpdatedState(certificate: certificate)],
  );

  blocTest<CertificatesBloc, CertificatesState>(
    'emits [Removing, Removed] when removeCertificate succeeds',
    build: () {
      when(() => webClient.removeCertificate(any())).thenAnswer((_) async => '1');
      return CertificatesBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(const CertificatesRemoveEvent(certificateId: '1')),
    expect: () => [CertificatesRemovingState(), const CertificatesRemovedState(certificateId: '1')],
    verify: (_) {
      verify(() => webClient.removeCertificate('1')).called(1);
    },
  );

  group('offline write-gating', () {
    blocTest<CertificatesBloc, CertificatesState>(
      'emits an offline Error and never calls addCertificate when disconnected',
      build: () => CertificatesBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(CertificatesAddEvent(certificate: certificate)),
      expect: () => [isA<CertificatesErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.addCertificate(any()));
      },
    );

    blocTest<CertificatesBloc, CertificatesState>(
      'emits an offline Error and never calls updateCertificate when disconnected',
      build: () => CertificatesBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(CertificatesUpdateEvent(certificate: certificate)),
      expect: () => [isA<CertificatesErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.updateCertificate(any()));
      },
    );

    blocTest<CertificatesBloc, CertificatesState>(
      'emits an offline Error and never calls removeCertificate when disconnected',
      build: () => CertificatesBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(const CertificatesRemoveEvent(certificateId: '1')),
      expect: () => [isA<CertificatesErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.removeCertificate(any()));
      },
    );
  });

  blocTest<CertificatesBloc, CertificatesState>(
    'maps a connection-error DioException to the offline message',
    build: () {
      when(() => webClient.addCertificate(any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.connectionError),
      );
      return CertificatesBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(CertificatesAddEvent(certificate: certificate)),
    expect: () => [CertificatesAddingState(), isA<CertificatesErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
  );
}
