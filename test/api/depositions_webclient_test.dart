import 'package:flutter_profile/common/api/depositions_webclient.dart';
import 'package:flutter_profile/common/models/deposition.dart';
import 'package:flutter_profile/common/network/http_exception.dart';
import 'package:flutter_profile/common/network/unauthorized_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import 'webclient_test_helpers.dart';

void main() {
  test('getDepositions parses a populated response', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('depositions.json', (server) => server.reply(200, {
          'id1': {'uid': 'uid1', 'name': 'Alexandre', 'relationship': 1, 'deposition': 'text', 'iconIndex': 0, 'isAnonymous': false},
        }));
    final webClient = DepositionsWebClient(dio: dio, auth: buildSignedInAuth());

    final depositions = await webClient.getDepositions();

    expect(depositions, [Deposition(id: 'id1', uid: 'uid1', name: 'Alexandre', relationship: 1, deposition: 'text', iconIndex: 0)]);
  });

  test('getDepositions returns empty list for an empty response object', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('depositions.json', (server) => server.reply(200, {}));
    final webClient = DepositionsWebClient(dio: dio, auth: buildSignedInAuth());

    expect(await webClient.getDepositions(), isEmpty);
  });

  test('getDepositions throws UnauthorizedException on a 401', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('depositions.json', (server) => server.reply(401, {'Message': 'unauthorized'}));
    final webClient = DepositionsWebClient(dio: dio, auth: buildSignedInAuth());

    try {
      await webClient.getDepositions();
      fail('expected an exception to be thrown');
    } catch (e) {
      final error = (e as dynamic).error;
      expect(error, isA<UnauthorizedException>());
    }
  });

  test('getDepositions throws HttpException on a 404', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onGet('depositions.json', (server) => server.reply(404, {'Message': 'not found'}));
    final webClient = DepositionsWebClient(dio: dio, auth: buildSignedInAuth());

    try {
      await webClient.getDepositions();
      fail('expected an exception to be thrown');
    } catch (e) {
      final error = (e as dynamic).error;
      expect(error, isA<HttpException>());
      expect((error as HttpException).code, 404);
    }
  });

  test('addDeposition posts to depositions.json and surfaces the status message', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPost(RegExp(r'^depositions\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Created'));
    final webClient = DepositionsWebClient(dio: dio, auth: buildSignedInAuth());

    final result = await webClient.addDeposition(Deposition(uid: 'uid1', name: 'Alexandre', relationship: 1, deposition: 'text', iconIndex: 0));

    expect(result, 'Created');
  });

  test('updateDeposition puts to depositions/{id}.json', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPut(RegExp(r'^depositions/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Updated'));
    final webClient = DepositionsWebClient(dio: dio, auth: buildSignedInAuth());

    final result = await webClient.updateDeposition(
      Deposition(id: 'id1', uid: 'uid1', name: 'Alexandre', relationship: 1, deposition: 'text', iconIndex: 0),
    );

    expect(result, 'Updated');
  });

  test('removeDeposition deletes depositions/{id}.json', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onDelete(RegExp(r'^depositions/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Deleted'));
    final webClient = DepositionsWebClient(dio: dio, auth: buildSignedInAuth());

    final result = await webClient.removeDeposition('id1');

    expect(result, 'Deleted');
  });
}
