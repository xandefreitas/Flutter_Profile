import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/certificate.dart';
import '../network/dio_base.dart';
import '../network/validate_response.dart';

class CertificatesWebClient {
  final Dio _dio = DioBase.getDio();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _idToken = '';

  Future<List<Certificate>> getCertificates() async {
    final List<Certificate> _certificates = [];
    _idToken = await _auth.currentUser!.getIdToken();

    try {
      final response = await _dio.get('certificates.json');
      validateResponse(response);
      response.data ??= {};
      if ((response.data as Map).isNotEmpty) {
        response.data.forEach((id, data) {
          _certificates.add(Certificate(
            id: id,
            course: data['course'],
            institution: data['institution'],
            description: data['description'],
            imageUrl: data['imageUrl'],
            credentialUrl: data['credentialUrl'],
            date: data['date'],
          ));
        });
      }
    } catch (e) {
      print(e);
    }
    return _certificates;
  }

  addCertificate(Certificate certificate) async {
    _idToken = await _auth.currentUser!.getIdToken();
    final response = await _dio.post('certificates.json?auth=$_idToken', data: certificate.toJson());
    validateResponse(response);
    return response.statusMessage ?? '';
  }

  removeCertificate(String certificateId) async {
    final response = await _dio.delete('certificates/$certificateId.json?auth=$_idToken');
    validateResponse(response);
    return response.statusMessage ?? '';
  }

  Future<String> updateCertificate(Certificate certificate) async {
    final response = await _dio.put(
      'certificates/${certificate.id}.json?auth=$_idToken',
      data: Certificate(
        course: certificate.course,
        institution: certificate.institution,
        description: certificate.description,
        imageUrl: certificate.imageUrl,
        credentialUrl: certificate.credentialUrl,
        date: certificate.date,
      ).toJson(),
    );
    validateResponse(response);
    return response.statusMessage ?? '';
  }
}
