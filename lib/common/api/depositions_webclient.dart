import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/deposition.dart';
import '../network/dio_base.dart';

class DepositionsWebClient {
  DepositionsWebClient({Dio? dio, FirebaseAuth? auth}) : _dio = dio ?? DioBase.getDio(), _auth = auth ?? FirebaseAuth.instance;

  final Dio _dio;
  final FirebaseAuth _auth;
  String? _idToken = '';

  Future<List<Deposition>> getDepositions() async {
    final List<Deposition> depositions = [];
    _idToken = await _auth.currentUser!.getIdToken();

    final response = await _dio.get<Map<String, dynamic>>('depositions.json');

    if ((response.data ??= {}).isNotEmpty) {
      response.data?.forEach((id, data) {
        depositions.add(
          Deposition(
            id: id,
            uid: (data as Map)['uid'],
            name: data['name'],
            relationship: data['relationship'],
            deposition: data['deposition'],
            iconIndex: data['iconIndex'],
            isAnonymous: data['isAnonymous'] ?? false,
          ),
        );
      });
    }
    return depositions;
  }

  Future<String> addDeposition(Deposition deposition) async {
    final response = await _dio.post('depositions.json?auth=$_idToken', data: deposition.toJson());
    return response.statusMessage ?? '';
  }

  Future<String> removeDeposition(String depositionId) async {
    final response = await _dio.delete('depositions/$depositionId.json?auth=$_idToken');
    return response.statusMessage ?? '';
  }

  Future<String> updateDeposition(Deposition deposition) async {
    final response = await _dio.put(
      'depositions/${deposition.id}.json?auth=$_idToken',
      data:
          Deposition(
            uid: deposition.uid,
            name: deposition.name,
            relationship: deposition.relationship,
            deposition: deposition.deposition,
            iconIndex: deposition.iconIndex,
            isAnonymous: deposition.isAnonymous,
          ).toJson(),
    );
    return response.statusMessage ?? '';
  }
}
