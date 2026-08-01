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

    final response = await _dio.get('workHistory.json');
    response.data ??= {};
    if ((response.data as Map).isNotEmpty) {
      response.data?.forEach((id, data) {
        companies.add(
          Company(
            id: id,
            name: data['name'] as String,
            occupations: data['occupations'] != null ? (data['occupations'] as List).map((e) => Occupation.fromMap(e)).toList() : <Occupation>[],
          ),
        );
      });
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
