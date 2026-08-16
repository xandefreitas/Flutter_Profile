import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/company.dart';
import '../network/rest_crud_webclient.dart';

class WorkHistoryWebClient {
  WorkHistoryWebClient({Dio? dio, FirebaseAuth? auth})
    : _client = RestCrudWebClient<Company>(
        resourcePath: 'workHistory',
        fromMap: Company.fromMap,
        toWriteMap: (company) => company.toMap()..remove('id'),
        withId: (company, id) => company.copyWith(id: id),
        dio: dio,
        auth: auth,
      );

  final RestCrudWebClient<Company> _client;

  Future<List<Company>> getWorkHistory() => _client.getAll();

  Future<Company> addWorkHistory(Company company) => _client.add(company);

  Future<String> removeWorkHistory(String companyId) => _client.remove(companyId);

  Future<Company> updateWorkHistory(Company company) => _client.update(company.id!, company);
}
