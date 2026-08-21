import 'package:flutter_profile/common/api/work_history_webclient.dart';
import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_work_history_database.dart';
import 'webclient_test_helpers.dart';

void main() {
  late FakeWorkHistoryDatabase database;

  setUp(() {
    database = FakeWorkHistoryDatabase();
  });

  test('watchWorkHistory parses occupations when present', () async {
    database.seedCompany('id1', {
      'name': 'Acme',
      'occupations': [
        {'role': 'Dev', 'startDate': '2020', 'endDate': '2022', 'description': 'Desc', 'isCurrentOccupation': false},
      ],
    });
    final webClient = WorkHistoryWebClient(database: database, auth: buildSignedInAuth());

    final companies = await webClient.watchWorkHistory().first;

    expect(companies, [
      Company(
        id: 'id1',
        name: 'Acme',
        occupations: [Occupation(role: 'Dev', startDate: '2020', endDate: '2022', description: 'Desc', isCurrentOccupation: false)],
      ),
    ]);
  });

  test('watchWorkHistory defaults occupations to an empty list when absent', () async {
    database.seedCompany('id1', {'name': 'Acme'});
    final webClient = WorkHistoryWebClient(database: database, auth: buildSignedInAuth());

    final companies = await webClient.watchWorkHistory().first;

    expect(companies.single.occupations, isEmpty);
  });

  test('watchWorkHistory emits an empty list for an empty node', () async {
    final webClient = WorkHistoryWebClient(database: database, auth: buildSignedInAuth());

    expect(await webClient.watchWorkHistory().first, isEmpty);
  });

  test('watchWorkHistory re-emits when a company is added', () async {
    final webClient = WorkHistoryWebClient(database: database, auth: buildSignedInAuth());
    final emissions = <List<Company>>[];
    final subscription = webClient.watchWorkHistory().listen(emissions.add);
    await Future<void>.delayed(Duration.zero);

    database
      ..seedCompany('id1', {'name': 'Acme'})
      ..emitChange();
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(emissions.last, [Company(id: 'id1', name: 'Acme', occupations: const [])]);
  });

  test('addWorkHistory posts to workHistory.json and returns the company with the server-assigned id', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPost(RegExp(r'^workHistory\.json'), (server) => server.reply(200, {'name': 'newId'}));
    final webClient = WorkHistoryWebClient(dio: dio, auth: buildSignedInAuth(), database: database);

    final result = await webClient.addWorkHistory(Company(name: 'Acme', occupations: const []));

    expect(result.id, 'newId');
    expect(result.name, 'Acme');
  });

  test('updateWorkHistory puts to workHistory/{id}.json and returns the updated company', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPut(RegExp(r'^workHistory/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Updated'));
    final webClient = WorkHistoryWebClient(dio: dio, auth: buildSignedInAuth(), database: database);

    final result = await webClient.updateWorkHistory(Company(id: 'id1', name: 'Acme', occupations: const []));

    expect(result.id, 'id1');
    expect(result.name, 'Acme');
  });

  test('removeWorkHistory deletes workHistory/{id}.json and returns the removed id', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onDelete(RegExp(r'^workHistory/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Deleted'));
    final webClient = WorkHistoryWebClient(dio: dio, auth: buildSignedInAuth(), database: database);

    final result = await webClient.removeWorkHistory('id1');

    expect(result, 'id1');
  });
}
