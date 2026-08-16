import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_profile/common/api/certificates_webclient.dart';
import 'package:flutter_profile/common/bloc/certificatesBloc/certificates_bloc.dart';
import 'package:flutter_profile/common/bloc/certificatesBloc/certificates_event.dart';
import 'package:flutter_profile/common/bloc/certificatesBloc/certificates_state.dart';
import 'package:flutter_profile/common/models/certificate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCertificatesWebClient extends Mock implements CertificatesWebClient {}

void main() {
  late MockCertificatesWebClient webClient;
  final certificate = Certificate(id: '1', course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1');

  setUpAll(() {
    registerFallbackValue(certificate);
  });

  setUp(() {
    webClient = MockCertificatesWebClient();
  });

  blocTest<CertificatesBloc, CertificatesState>(
    'emits [Fetching, Fetched] when getCertificates succeeds',
    build: () {
      when(() => webClient.getCertificates()).thenAnswer((_) async => [certificate]);
      return CertificatesBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(CertificatesFetchEvent()),
    expect: () => [CertificatesFetchingState(), CertificatesFetchedState(certificates: [certificate])],
  );

  blocTest<CertificatesBloc, CertificatesState>(
    'emits [Fetching, Error] when getCertificates throws a DioException',
    build: () {
      when(() => webClient.getCertificates()).thenThrow(DioException(requestOptions: RequestOptions(path: '/x'), error: Exception('boom')));
      return CertificatesBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(CertificatesFetchEvent()),
    expect: () => [CertificatesFetchingState(), isA<CertificatesErrorState>().having((s) => s.exception, 'exception', 'Exception: boom')],
  );

  blocTest<CertificatesBloc, CertificatesState>(
    'emits [Fetching, Error] when getCertificates throws a plain exception',
    build: () {
      final exception = Exception('plain');
      when(() => webClient.getCertificates()).thenThrow(exception);
      return CertificatesBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(CertificatesFetchEvent()),
    expect: () => [CertificatesFetchingState(), isA<CertificatesErrorState>().having((s) => s.exception, 'exception', isA<Exception>())],
  );

  blocTest<CertificatesBloc, CertificatesState>(
    'emits [Adding, Added] when addCertificate succeeds',
    build: () {
      when(() => webClient.addCertificate(any())).thenAnswer((_) async => certificate);
      return CertificatesBloc(webClient: webClient);
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
      return CertificatesBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(CertificatesUpdateEvent(certificate: certificate)),
    expect: () => [CertificatesUpdatingState(), CertificatesUpdatedState(certificate: certificate)],
  );

  blocTest<CertificatesBloc, CertificatesState>(
    'emits [Removing, Removed] when removeCertificate succeeds',
    build: () {
      when(() => webClient.removeCertificate(any())).thenAnswer((_) async => '1');
      return CertificatesBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(const CertificatesRemoveEvent(certificateId: '1')),
    expect: () => [CertificatesRemovingState(), const CertificatesRemovedState(certificateId: '1')],
    verify: (_) {
      verify(() => webClient.removeCertificate('1')).called(1);
    },
  );
}
