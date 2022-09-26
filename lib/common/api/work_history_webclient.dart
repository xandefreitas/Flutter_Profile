import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/common/models/occupation.dart';

import '../network/dio_base.dart';

class WorkHistoryWebClient {
  final Dio _dio = DioBase.getDio();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _idToken = '';

  Future<List<Company>> getWorkHistory() async {
    final List<Company> _companies = [];
    _idToken = await _auth.currentUser!.getIdToken();

    try {
      final response = await _dio.get('workHistory.json');
      response.data ??= {};
      if ((response.data as Map).isNotEmpty) {
        response.data?.forEach((id, data) {
          _companies.add(
            Company(
              id: id,
              name: data['name'] as String,
              occupations: data['occupations'] != null ? (data['occupations'] as List).map((e) => Occupation.fromMap(e)).toList() : <Occupation>[],
            ),
          );
        });
      }
    } catch (e) {
      print(e);
    }
    return _companies;
  }

  addWorkHistory(Company company) async {
    final response = await _dio.post('workHistory.json?auth=$_idToken', data: company.toJson());
    return response.statusMessage ?? '';
  }

  removeWorkHistory(String companyId) async {
    final response = await _dio.delete('workHistory/$companyId.json?auth=$_idToken');
    return response.statusMessage ?? '';
  }

  Future<String> updateWorkHistory(Company company) async {
    final response = await _dio.put(
      'workHistory/${company.id}.json?auth=$_idToken',
      data: Company(
        name: company.name,
        occupations: company.occupations,
      ).toJson(),
    );
    return response.statusMessage ?? '';
  }
}
