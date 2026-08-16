import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/deposition.dart';
import '../network/rest_crud_webclient.dart';

class DepositionsWebClient {
  DepositionsWebClient({Dio? dio, FirebaseAuth? auth})
    : _client = RestCrudWebClient<Deposition>(
        resourcePath: 'depositions',
        fromMap: Deposition.fromMap,
        toWriteMap: (deposition) => deposition.toMap()..remove('id'),
        withId: (deposition, id) => deposition.copyWith(id: id),
        dio: dio,
        auth: auth,
      );

  final RestCrudWebClient<Deposition> _client;

  Future<List<Deposition>> getDepositions() => _client.getAll();

  Future<Deposition> addDeposition(Deposition deposition) => _client.add(deposition);

  Future<String> removeDeposition(String depositionId) => _client.remove(depositionId);

  Future<Deposition> updateDeposition(Deposition deposition) => _client.update(deposition.id!, deposition);
}
