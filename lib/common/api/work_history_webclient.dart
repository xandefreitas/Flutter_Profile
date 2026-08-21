import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/company.dart';
import '../network/database/firebase_work_history_database.dart';
import '../network/database/work_history_database.dart';
import '../network/rest_crud_webclient.dart';

class WorkHistoryWebClient {
  WorkHistoryWebClient({Dio? dio, FirebaseAuth? auth, WorkHistoryDatabase? database})
    : _client = RestCrudWebClient<Company>(
        resourcePath: 'workHistory',
        fromMap: Company.fromMap,
        toWriteMap: (company) => company.toMap()..remove('id'),
        withId: (company, id) => company.copyWith(id: id),
        dio: dio,
        auth: auth,
      ),
      _database = database ?? FirebaseWorkHistoryDatabase();

  final RestCrudWebClient<Company> _client;
  final WorkHistoryDatabase _database;

  /// Live list of companies, re-emitting whenever one is added, updated, or
  /// removed by any user.
  Stream<List<Company>> watchWorkHistory() {
    return _database.watchWorkHistory().map((workHistoryData) {
      return workHistoryData.entries
          .map((entry) => Company.fromMap(Map<String, dynamic>.from(entry.value as Map)).copyWith(id: entry.key))
          .toList();
    });
  }

  Future<Company> addWorkHistory(Company company) => _client.add(company);

  Future<String> removeWorkHistory(String companyId) => _client.remove(companyId);

  Future<Company> updateWorkHistory(Company company) => _client.update(company.id!, company);
}
