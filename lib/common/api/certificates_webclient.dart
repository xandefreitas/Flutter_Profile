import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/certificate.dart';
import '../network/database/certificates_database.dart';
import '../network/database/firebase_certificates_database.dart';
import '../network/dio_base.dart';
import '../network/rest_crud_webclient.dart';

class CertificatesWebClient {
  CertificatesWebClient({Dio? dio, FirebaseAuth? auth, CertificatesDatabase? database})
    : _client = RestCrudWebClient<Certificate>(
        resourcePath: 'certificates',
        fromMap: Certificate.fromMap,
        toWriteMap: (certificate) => certificate.toMap()..remove('id'),
        withId: (certificate, id) => certificate.copyWith(id: id),
        dio: dio,
        auth: auth,
      ),
      _database = database ?? FirebaseCertificatesDatabase();

  final RestCrudWebClient<Certificate> _client;
  final CertificatesDatabase _database;

  /// Live list of certificates, re-emitting whenever one is added, updated,
  /// or removed by any user.
  Stream<List<Certificate>> watchCertificates() {
    return _database.watchCertificates().map((certificatesData) {
      return certificatesData.entries
          .map((entry) => Certificate.fromMap(Map<String, dynamic>.from(entry.value as Map)).copyWith(id: entry.key))
          .toList();
    });
  }

  Future<Certificate> addCertificate(Certificate certificate) => _client.add(certificate);

  Future<String> removeCertificate(String certificateId) => _client.remove(certificateId);

  Future<Certificate> updateCertificate(Certificate certificate) => _client.update(certificate.id!, certificate);

  static Future<int?>? validateImageUrl(String imageUrl) async {
    final response = await DioBase.getDio().get(imageUrl);
    return response.statusCode;
  }
}
