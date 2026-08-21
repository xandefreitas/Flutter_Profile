import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/deposition.dart';
import '../network/database/depositions_database.dart';
import '../network/database/firebase_depositions_database.dart';
import '../network/rest_crud_webclient.dart';

class DepositionsWebClient {
  DepositionsWebClient({Dio? dio, FirebaseAuth? auth, DepositionsDatabase? database})
    : _client = RestCrudWebClient<Deposition>(
        resourcePath: 'depositions',
        fromMap: Deposition.fromMap,
        toWriteMap: (deposition) => deposition.toMap()..remove('id'),
        withId: (deposition, id) => deposition.copyWith(id: id),
        dio: dio,
        auth: auth,
      ),
      _database = database ?? FirebaseDepositionsDatabase();

  final RestCrudWebClient<Deposition> _client;
  final DepositionsDatabase _database;

  /// Live list of depositions sorted oldest-first by creation/update time,
  /// re-emitting whenever one is added, updated, or removed by any user.
  Stream<List<Deposition>> watchDepositions() {
    return _database.watchDepositions().map((depositionsData) {
      return depositionsData.entries
          .map((entry) => Deposition.fromMap(Map<String, dynamic>.from(entry.value as Map)).copyWith(id: entry.key))
          .toList()
          // Ties (e.g. records predating the updatedAt field, all
          // defaulting to 0) fall back to push-key order, which is itself
          // chronological.
          ..sort((a, b) {
            final byUpdatedAt = a.updatedAt.compareTo(b.updatedAt);
            return byUpdatedAt != 0 ? byUpdatedAt : (a.id ?? '').compareTo(b.id ?? '');
          });
    });
  }

  Future<Deposition> addDeposition(Deposition deposition) => _client.add(deposition);

  Future<String> removeDeposition(String depositionId) => _client.remove(depositionId);

  Future<Deposition> updateDeposition(Deposition deposition) => _client.update(deposition.id!, deposition);
}
