import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../core/core.dart';
import 'deep_cast.dart';
import 'depositions_database.dart';

class FirebaseDepositionsDatabase implements DepositionsDatabase {
  FirebaseDepositionsDatabase({DatabaseReference? root})
    : _root = root ?? FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: Consts.databaseUrl).ref();

  final DatabaseReference _root;

  @override
  Stream<Map<String, dynamic>> watchDepositions() {
    return _root.child('depositions').onValue.map((event) => deepCastDatabaseMap(event.snapshot.value));
  }
}
