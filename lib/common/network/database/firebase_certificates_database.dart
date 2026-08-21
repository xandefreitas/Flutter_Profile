import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../core/core.dart';
import 'certificates_database.dart';

class FirebaseCertificatesDatabase implements CertificatesDatabase {
  FirebaseCertificatesDatabase({DatabaseReference? root})
    : _root = root ?? FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: Consts.databaseUrl).ref();

  final DatabaseReference _root;

  @override
  Stream<Map<String, dynamic>> watchCertificates() {
    return _root.child('certificates').onValue.map((event) => _deepCastMap(event.snapshot.value));
  }

  Map<String, dynamic> _deepCastMap(Object? value) {
    if (value is! Map) return <String, dynamic>{};
    return value.map((key, v) => MapEntry(key.toString(), v is Map ? _deepCastMap(v) : v));
  }
}
