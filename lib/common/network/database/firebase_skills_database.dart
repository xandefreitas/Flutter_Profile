import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../core/core.dart';
import 'deep_cast.dart';
import 'skills_database.dart';

class FirebaseSkillsDatabase implements SkillsDatabase {
  FirebaseSkillsDatabase({DatabaseReference? root})
    : _root = root ?? FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: Consts.databaseUrl).ref();

  final DatabaseReference _root;

  @override
  Stream<Map<String, dynamic>> watchSkills() {
    return _root.child('skills').onValue.map((event) => deepCastDatabaseMap(event.snapshot.value));
  }

  @override
  Stream<Map<String, dynamic>> watchUserRecommendations(String userId) {
    return _root.child('userRecommended/$userId').onValue.map((event) => deepCastDatabaseMap(event.snapshot.value));
  }

  @override
  Future<void> addSkill(String title) {
    return _root.child('skills').push().set({'title': title, 'likesQuantity': 0});
  }

  @override
  Future<void> removeSkill(String skillId) {
    return _root.child('skills/$skillId').remove();
  }

  @override
  Future<void> setRecommendation({required String userId, required String skillId, required bool recommended, required int delta}) {
    return _root.update({'userRecommended/$userId/$skillId': recommended, 'skills/$skillId/likesQuantity': ServerValue.increment(delta)});
  }
}
