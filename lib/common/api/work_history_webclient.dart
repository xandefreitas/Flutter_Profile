import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/company.dart';
import '../models/occupation.dart';

import '../network/dio_base.dart';

class WorkHistoryWebClient {
  final Dio _dio = DioBase.getDio();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _idToken = '';

  Future<List<Company>> getWorkHistory() async {
    final List<Company> companies = [];
    _idToken = await _auth.currentUser!.getIdToken();

    final response = await _dio.get<Map<String, dynamic>>('workHistory.json');
    final Map<String, dynamic> workHistory = response.data ?? {};
    for (final entry in workHistory.entries) {
      final data = entry.value as Map<String, dynamic>;
      final occupationsData = data['occupations'] as List<dynamic>?;
      companies.add(
        Company(
          id: entry.key,
          name: data['name'] as String,
          occupations: occupationsData != null ? occupationsData.map((e) => Occupation.fromMap(e as Map<String, dynamic>)).toList() : <Occupation>[],
        ),
      );
    }
    return companies;
  }

  Future<String> addWorkHistory(Company company) async {
    final response = await _dio.post('workHistory.json?auth=$_idToken', data: company.toJson());
    return response.statusMessage ?? '';
  }

  Future<String> removeWorkHistory(String companyId) async {
    final response = await _dio.delete('workHistory/$companyId.json?auth=$_idToken');
    return response.statusMessage ?? '';
  }

  Future<String> updateWorkHistory(Company company) async {
    final response = await _dio.put(
      'workHistory/${company.id}.json?auth=$_idToken',
      data: Company(name: company.name, occupations: company.occupations).toJson(),
    );
    return response.statusMessage ?? '';
  }
}
