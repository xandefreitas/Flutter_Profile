import 'package:flutter_profile/common/api/depositions_webclient.dart';
import 'package:flutter_profile/common/models/deposition.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_depositions_database.dart';
import 'webclient_test_helpers.dart';

void main() {
  late FakeDepositionsDatabase database;

  setUp(() {
    database = FakeDepositionsDatabase();
  });

  test('watchDepositions parses a populated response', () async {
    database.seedDeposition('id1', {'uid': 'uid1', 'name': 'Alexandre', 'relationship': 1, 'deposition': 'text', 'iconIndex': 0, 'isAnonymous': false});
    final webClient = DepositionsWebClient(database: database, auth: buildSignedInAuth());

    final depositions = await webClient.watchDepositions().first;

    expect(depositions, [Deposition(id: 'id1', uid: 'uid1', name: 'Alexandre', relationship: 1, deposition: 'text', iconIndex: 0)]);
  });

  test('watchDepositions emits an empty list for an empty node', () async {
    final webClient = DepositionsWebClient(database: database, auth: buildSignedInAuth());

    expect(await webClient.watchDepositions().first, isEmpty);
  });

  test('watchDepositions sorts oldest-first by updatedAt', () async {
    database
      ..seedDeposition('id1', {'uid': 'uid1', 'name': 'A', 'relationship': 0, 'deposition': 'newest', 'iconIndex': 0, 'updatedAt': 300})
      ..seedDeposition('id2', {'uid': 'uid2', 'name': 'B', 'relationship': 0, 'deposition': 'oldest', 'iconIndex': 0, 'updatedAt': 100})
      ..seedDeposition('id3', {'uid': 'uid3', 'name': 'C', 'relationship': 0, 'deposition': 'middle', 'iconIndex': 0, 'updatedAt': 200});
    final webClient = DepositionsWebClient(database: database, auth: buildSignedInAuth());

    final depositions = await webClient.watchDepositions().first;

    expect(depositions.map((d) => d.deposition), ['oldest', 'middle', 'newest']);
  });

  test('watchDepositions falls back to push-key order when updatedAt ties (legacy records)', () async {
    database
      ..seedDeposition('id2', {'uid': 'uid2', 'name': 'B', 'relationship': 0, 'deposition': 'second', 'iconIndex': 0})
      ..seedDeposition('id1', {'uid': 'uid1', 'name': 'A', 'relationship': 0, 'deposition': 'first', 'iconIndex': 0});
    final webClient = DepositionsWebClient(database: database, auth: buildSignedInAuth());

    final depositions = await webClient.watchDepositions().first;

    expect(depositions.map((d) => d.deposition), ['first', 'second']);
  });

  test('watchDepositions re-emits when a deposition is added', () async {
    final webClient = DepositionsWebClient(database: database, auth: buildSignedInAuth());
    final emissions = <List<Deposition>>[];
    final subscription = webClient.watchDepositions().listen(emissions.add);
    await Future<void>.delayed(Duration.zero);

    database
      ..seedDeposition('id1', {'uid': 'uid1', 'name': 'Alexandre', 'relationship': 1, 'deposition': 'text', 'iconIndex': 0, 'isAnonymous': false})
      ..emitChange();
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(emissions.last, [Deposition(id: 'id1', uid: 'uid1', name: 'Alexandre', relationship: 1, deposition: 'text', iconIndex: 0)]);
  });

  test('addDeposition posts to depositions.json and returns the deposition with the server-assigned id', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPost(RegExp(r'^depositions\.json'), (server) => server.reply(200, {'name': 'newId'}));
    final webClient = DepositionsWebClient(dio: dio, auth: buildSignedInAuth(), database: database);

    final result = await webClient.addDeposition(Deposition(uid: 'uid1', name: 'Alexandre', relationship: 1, deposition: 'text', iconIndex: 0));

    expect(result.id, 'newId');
    expect(result.name, 'Alexandre');
  });

  test('updateDeposition puts to depositions/{id}.json and returns the updated deposition', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPut(RegExp(r'^depositions/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Updated'));
    final webClient = DepositionsWebClient(dio: dio, auth: buildSignedInAuth(), database: database);

    final result = await webClient.updateDeposition(
      Deposition(id: 'id1', uid: 'uid1', name: 'Alexandre', relationship: 1, deposition: 'text', iconIndex: 0),
    );

    expect(result.id, 'id1');
    expect(result.name, 'Alexandre');
  });

  test('removeDeposition deletes depositions/{id}.json and returns the removed id', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onDelete(RegExp(r'^depositions/id1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Deleted'));
    final webClient = DepositionsWebClient(dio: dio, auth: buildSignedInAuth(), database: database);

    final result = await webClient.removeDeposition('id1');

    expect(result, 'id1');
  });
}
