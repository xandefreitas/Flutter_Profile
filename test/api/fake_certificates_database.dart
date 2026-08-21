import 'dart:async';

import 'package:flutter_profile/common/network/database/certificates_database.dart';

/// In-memory [CertificatesDatabase] used by [CertificatesWebClient] unit
/// tests.
///
/// No firebase_database-compatible mocking package supports the version
/// this app depends on, so this fake stands in for it.
class FakeCertificatesDatabase implements CertificatesDatabase {
  final Map<String, Map<String, dynamic>> _certificates = {};
  final StreamController<Map<String, dynamic>> _changes = StreamController.broadcast();
  Object? errorToThrow;

  void seedCertificate(String id, Map<String, dynamic> data) {
    _certificates[id] = data;
  }

  Map<String, Map<String, dynamic>> get certificatesSnapshot => _certificates.map((id, data) => MapEntry(id, Map<String, dynamic>.from(data)));

  @override
  Stream<Map<String, dynamic>> watchCertificates() {
    if (errorToThrow != null) return Stream.error(errorToThrow!);
    return Stream.multi((controller) {
      controller.add(certificatesSnapshot);
      final subscription = _changes.stream.listen(controller.add, onError: controller.addError);
      controller.onCancel = subscription.cancel;
    });
  }

  void emitChange() => _changes.add(certificatesSnapshot);
}
