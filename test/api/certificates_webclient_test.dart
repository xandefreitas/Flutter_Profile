import 'package:flutter_profile/common/api/certificates_webclient.dart';
import 'package:flutter_profile/common/models/certificate.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_certificates_database.dart';
import 'webclient_test_helpers.dart';

void main() {
  late FakeCertificatesDatabase database;

  setUp(() {
    database = FakeCertificatesDatabase();
  });

  test('watchCertificates parses a populated response', () async {
    database.seedCertificate('id1', {'course': 'Course', 'institution': 'Institution', 'description': 'Desc', 'credentialUrl': 'url', 'date': '2024', 'duration': '1'});
    final webClient = CertificatesWebClient(database: database, auth: buildSignedInAuth());

    final certificates = await webClient.watchCertificates().first;

    expect(certificates, [
      Certificate(id: 'id1', imageUrl: null, course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1'),
    ]);
  });

  test('watchCertificates emits an empty list for an empty node', () async {
    final webClient = CertificatesWebClient(database: database, auth: buildSignedInAuth());

    expect(await webClient.watchCertificates().first, isEmpty);
  });

  test('watchCertificates re-emits when a certificate is added', () async {
    final webClient = CertificatesWebClient(database: database, auth: buildSignedInAuth());
    final emissions = <List<Certificate>>[];
    final subscription = webClient.watchCertificates().listen(emissions.add);
    await Future<void>.delayed(Duration.zero);

    database
      ..seedCertificate('id1', {'course': 'Course', 'institution': 'Institution', 'description': 'Desc', 'credentialUrl': 'url', 'date': '2024', 'duration': '1'})
      ..emitChange();
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(emissions.last, [
      Certificate(id: 'id1', imageUrl: null, course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1'),
    ]);
  });

  test('addCertificate posts to certificates.json and returns the certificate with the server-assigned id', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPost(RegExp(r'^certificates\.json'), (server) => server.reply(200, {'name': 'newId'}));
    final webClient = CertificatesWebClient(dio: dio, auth: buildSignedInAuth(), database: database);

    final result = await webClient.addCertificate(
      Certificate(course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1'),
    );

    expect(result.id, 'newId');
    expect(result.course, 'Course');
  });

  test('updateCertificate puts to certificates/{id}.json and returns the updated certificate', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPut(RegExp(r'^certificates/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Updated'));
    final webClient = CertificatesWebClient(dio: dio, auth: buildSignedInAuth(), database: database);

    final result = await webClient.updateCertificate(
      Certificate(id: 'id1', course: 'Course', institution: 'Institution', description: 'Desc', credentialUrl: 'url', date: '2024', duration: '1'),
    );

    expect(result.id, 'id1');
    expect(result.course, 'Course');
  });

  test('removeCertificate deletes certificates/{id}.json and returns the removed id', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onDelete(RegExp(r'^certificates/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Deleted'));
    final webClient = CertificatesWebClient(dio: dio, auth: buildSignedInAuth(), database: database);

    final result = await webClient.removeCertificate('id1');

    expect(result, 'id1');
  });
}
