import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../core/core.dart';
import 'deep_cast.dart';
import 'work_history_database.dart';

class FirebaseWorkHistoryDatabase implements WorkHistoryDatabase {
  FirebaseWorkHistoryDatabase({DatabaseReference? root})
    : _root = root ?? FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: Consts.databaseUrl).ref();

  final DatabaseReference _root;

  @override
  Stream<Map<String, dynamic>> watchWorkHistory() {
    return _root.child('workHistory').onValue.map((event) => deepCastDatabaseMap(event.snapshot.value));
  }
}
