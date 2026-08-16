import 'package:flutter_profile/common/api/work_history_webclient.dart';
import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_profile/common/network/http_exception.dart';
import 'package:flutter_profile/common/network/unauthorized_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import 'webclient_test_helpers.dart';

void main() {
  test('getWorkHistory parses occupations when present', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('workHistory.json', (server) => server.reply(200, {
          'id1': {
            'name': 'Acme',
            'occupations': [
              {'role': 'Dev', 'startDate': '2020', 'endDate': '2022', 'description': 'Desc', 'isCurrentOccupation': false},
            ],
          },
        }));
    final webClient = WorkHistoryWebClient(dio: dio, auth: buildSignedInAuth());

    final companies = await webClient.getWorkHistory();

    expect(companies, [
      Company(
        id: 'id1',
        name: 'Acme',
        occupations: [Occupation(role: 'Dev', startDate: '2020', endDate: '2022', description: 'Desc', isCurrentOccupation: false)],
      ),
    ]);
  });

  test('getWorkHistory defaults occupations to an empty list when absent', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('workHistory.json', (server) => server.reply(200, {
          'id1': {'name': 'Acme'},
        }));
    final webClient = WorkHistoryWebClient(dio: dio, auth: buildSignedInAuth());

    final companies = await webClient.getWorkHistory();

    expect(companies.single.occupations, isEmpty);
  });

  test('getWorkHistory returns empty list for an empty response object', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('workHistory.json', (server) => server.reply(200, {}));
    final webClient = WorkHistoryWebClient(dio: dio, auth: buildSignedInAuth());

    expect(await webClient.getWorkHistory(), isEmpty);
  });

  test('getWorkHistory throws UnauthorizedException on a 401', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('workHistory.json', (server) => server.reply(401, {'Message': 'unauthorized'}));
    final webClient = WorkHistoryWebClient(dio: dio, auth: buildSignedInAuth());

    try {
      await webClient.getWorkHistory();
      fail('expected an exception to be thrown');
    } catch (e) {
      expect((e as dynamic).error, isA<UnauthorizedException>());
    }
  });

  test('getWorkHistory throws HttpException on a 404', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('workHistory.json', (server) => server.reply(404, {'Message': 'not found'}));
    final webClient = WorkHistoryWebClient(dio: dio, auth: buildSignedInAuth());

    try {
      await webClient.getWorkHistory();
      fail('expected an exception to be thrown');
    } catch (e) {
      final error = (e as dynamic).error;
      expect(error, isA<HttpException>());
      expect((error as HttpException).code, 404);
    }
  });

  test('addWorkHistory posts to workHistory.json and returns the company with the server-assigned id', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPost(RegExp(r'^workHistory\.json'), (server) => server.reply(200, {'name': 'newId'}));
    final webClient = WorkHistoryWebClient(dio: dio, auth: buildSignedInAuth());

    final result = await webClient.addWorkHistory(Company(name: 'Acme', occupations: const []));

    expect(result.id, 'newId');
    expect(result.name, 'Acme');
  });

  test('updateWorkHistory puts to workHistory/{id}.json and returns the updated company', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPut(RegExp(r'^workHistory/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Updated'));
    final webClient = WorkHistoryWebClient(dio: dio, auth: buildSignedInAuth());

    final result = await webClient.updateWorkHistory(Company(id: 'id1', name: 'Acme', occupations: const []));

    expect(result.id, 'id1');
    expect(result.name, 'Acme');
  });

  test('removeWorkHistory deletes workHistory/{id}.json and returns the removed id', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onDelete(RegExp(r'^workHistory/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Deleted'));
    final webClient = WorkHistoryWebClient(dio: dio, auth: buildSignedInAuth());

    final result = await webClient.removeWorkHistory('id1');

    expect(result, 'id1');
  });
}
