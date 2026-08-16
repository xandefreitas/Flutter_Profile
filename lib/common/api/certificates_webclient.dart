import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/certificate.dart';
import '../network/dio_base.dart';
import '../network/rest_crud_webclient.dart';

class CertificatesWebClient {
  CertificatesWebClient({Dio? dio, FirebaseAuth? auth})
    : _client = RestCrudWebClient<Certificate>(
        resourcePath: 'certificates',
        fromMap: Certificate.fromMap,
        toWriteMap: (certificate) => certificate.toMap()..remove('id'),
        withId: (certificate, id) => certificate.copyWith(id: id),
        dio: dio,
        auth: auth,
      );

  final RestCrudWebClient<Certificate> _client;

  Future<List<Certificate>> getCertificates() => _client.getAll();

  Future<Certificate> addCertificate(Certificate certificate) => _client.add(certificate);

  Future<String> removeCertificate(String certificateId) => _client.remove(certificateId);

  Future<Certificate> updateCertificate(Certificate certificate) => _client.update(certificate.id!, certificate);

  static Future<int?>? validateImageUrl(String imageUrl) async {
    final response = await DioBase.getDio().get(imageUrl);
    return response.statusCode;
  }
}
