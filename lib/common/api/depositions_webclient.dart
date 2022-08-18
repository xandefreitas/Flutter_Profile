import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/deposition.dart';
import '../network/dio_base.dart';
import '../network/validate_response.dart';

class DepositionsWebClient {
  final Dio _dio = DioBase.getDio();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String idToken = '';

  Future<List<Deposition>> getDepositions() async {
    final List<Deposition> _depositions = [];
    idToken = await auth.currentUser!.getIdToken();

    try {
      final response = await _dio.get('depositions.json');
      validateResponse(response);
      response.data ??= [];
      response.data.forEach((id, data) {
        _depositions.add(Deposition(
          id: id,
          uid: data['uid'],
          name: data['name'],
          relationship: data['relationship'],
          deposition: data['deposition'],
          iconIndex: data['iconIndex'],
        ));
      });
    } catch (e) {
      print(e);
    }
    return _depositions;
  }

  addDeposition(Deposition deposition) async {
    final response = await _dio.post('depositions.json?auth=$idToken', data: deposition.toJson());
    validateResponse(response);
    return response.statusMessage ?? '';
  }

  removeDeposition(String depositionId) async {
    final response = await _dio.delete('depositions/$depositionId.json?auth=$idToken');
    validateResponse(response);
    return response.statusMessage ?? '';
  }

  Future<String> updateDeposition(Deposition deposition) async {
    final response = await _dio.put(
      'depositions/${deposition.id}.json?auth=$idToken',
      data: Deposition(
        uid: deposition.uid,
        name: deposition.name,
        relationship: deposition.relationship,
        deposition: deposition.deposition,
        iconIndex: deposition.iconIndex,
      ).toJson(),
    );
    validateResponse(response);
    return response.statusMessage ?? '';
  }
}
