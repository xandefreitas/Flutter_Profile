import 'package:flutter_profile/common/api/certificates_webclient.dart';
import 'package:flutter_profile/common/models/certificate.dart';
import 'package:flutter_profile/common/network/http_exception.dart';
import 'package:flutter_profile/common/network/unauthorized_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import 'webclient_test_helpers.dart';

void main() {
  test('getCertificates parses a populated response', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('certificates.json', (server) => server.reply(200, {
          'id1': {'course': 'Course', 'institution': 'Institution', 'description': 'Desc', 'credentialUrl': 'url', 'date': '2024', 'duration': '1'},
        }));
    final webClient = CertificatesWebClient(dio: dio, auth: buildSignedInAuth());

    final certificates = await webClient.getCertificates();

    expect(certificates, [
      Certificate(id: 'id1', imageUrl: null, course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1'),
    ]);
  });

  test('getCertificates returns empty list for an empty response object', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('certificates.json', (server) => server.reply(200, {}));
    final webClient = CertificatesWebClient(dio: dio, auth: buildSignedInAuth());

    expect(await webClient.getCertificates(), isEmpty);
  });

  test('getCertificates throws UnauthorizedException on a 401', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('certificates.json', (server) => server.reply(401, {'Message': 'unauthorized'}));
    final webClient = CertificatesWebClient(dio: dio, auth: buildSignedInAuth());

    try {
      await webClient.getCertificates();
      fail('expected an exception to be thrown');
    } catch (e) {
      expect(e, isA<Exception>());
      final error = (e as dynamic).error;
      expect(error, isA<UnauthorizedException>());
      expect((error as UnauthorizedException).message, 'unauthorized');
    }
  });

  test('getCertificates throws HttpException on a 404', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('certificates.json', (server) => server.reply(404, {'Message': 'not found'}));
    final webClient = CertificatesWebClient(dio: dio, auth: buildSignedInAuth());

    try {
      await webClient.getCertificates();
      fail('expected an exception to be thrown');
    } catch (e) {
      final error = (e as dynamic).error;
      expect(error, isA<HttpException>());
      expect((error as HttpException).code, 404);
    }
  });

  test('addCertificate posts to certificates.json and returns the certificate with the server-assigned id', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPost(RegExp(r'^certificates\.json'), (server) => server.reply(200, {'name': 'newId'}));
    final webClient = CertificatesWebClient(dio: dio, auth: buildSignedInAuth());

    final result = await webClient.addCertificate(
      Certificate(course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1'),
    );

    expect(result.id, 'newId');
    expect(result.course, 'Course');
  });

  test('updateCertificate puts to certificates/{id}.json and returns the updated certificate', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPut(RegExp(r'^certificates/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Updated'));
    final webClient = CertificatesWebClient(dio: dio, auth: buildSignedInAuth());

    final result = await webClient.updateCertificate(
      Certificate(id: 'id1', course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1'),
    );

    expect(result.id, 'id1');
    expect(result.course, 'Course');
  });

  test('removeCertificate deletes certificates/{id}.json and returns the removed id', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onDelete(RegExp(r'^certificates/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Deleted'));
    final webClient = CertificatesWebClient(dio: dio, auth: buildSignedInAuth());

    final result = await webClient.removeCertificate('id1');

    expect(result, 'id1');
  });
}
