import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/certificate.dart';
import '../network/dio_base.dart';

class CertificatesWebClient {
  final Dio _dio = DioBase.getDio();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _idToken = '';

  Future<List<Certificate>> getCertificates() async {
    final List<Certificate> certificates = [];
    _idToken = await _auth.currentUser!.getIdToken();

    final response = await _dio.get('certificates.json');
    response.data ??= {};
    if ((response.data as Map).isNotEmpty) {
      response.data.forEach((id, data) {
        certificates.add(Certificate(
          id: id,
          course: data['course'],
          institution: data['institution'],
          description: data['description'],
          descriptionEn: data['descriptionEn'],
          imageUrl: data['imageUrl'],
          credentialUrl: data['credentialUrl'],
          date: data['date'],
          duration: data['duration'],
        ));
      });
    }
    return certificates;
  }

  addCertificate(Certificate certificate) async {
    final response = await _dio.post('certificates.json?auth=$_idToken', data: certificate.toJson());
    return response.statusMessage ?? '';
  }

  removeCertificate(String certificateId) async {
    final response = await _dio.delete('certificates/$certificateId.json?auth=$_idToken');
    return response.statusMessage ?? '';
  }

  Future<String> updateCertificate(Certificate certificate) async {
    final response = await _dio.put(
      'certificates/${certificate.id}.json?auth=$_idToken',
      data: Certificate(
        course: certificate.course,
        institution: certificate.institution,
        description: certificate.description,
        descriptionEn: certificate.descriptionEn,
        imageUrl: certificate.imageUrl,
        credentialUrl: certificate.credentialUrl,
        date: certificate.date,
        duration: certificate.duration,
      ).toJson(),
    );
    return response.statusMessage ?? '';
  }

  static validateImageUrl(String imageUrl) async {
    final response = await Dio().get(imageUrl);
    return response.statusCode;
  }
}
