import 'package:firebase_auth/firebase_auth.dart';

import '../models/skill.dart';
import '../network/database/firebase_skills_database.dart';
import '../network/database/skills_database.dart';

class SkillsWebClient {
  SkillsWebClient({SkillsDatabase? database, FirebaseAuth? auth}) : _database = database ?? FirebaseSkillsDatabase(), _auth = auth ?? FirebaseAuth.instance;

  final SkillsDatabase _database;
  final FirebaseAuth _auth;

  /// Live list of skills, merged with the current user's recommendations.
  /// Re-emits whenever any user's vote changes a skill's like count.
  Stream<List<Skill>> watchSkills() {
    final userId = _auth.currentUser!.uid;
    return _database.watchSkills().asyncMap((skillsData) async {
      final recommended = await _database.getUserRecommendations(userId);
      return skillsData.entries.map((entry) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        return Skill(
          id: entry.key,
          title: data['title'] as String,
          likesQuantity: (data['likesQuantity'] as num?)?.toInt() ?? 0,
          isRecommended: recommended[entry.key] == true,
        );
      }).toList();
    });
  }

  Future<void> addNewSkill(String title) => _database.addSkill(title);

  Future<void> removeSkill(String skillId) => _database.removeSkill(skillId);

  /// Toggles [skill]'s recommendation for [userId] and adjusts its like
  /// count by exactly one, atomically, so concurrent votes from different
  /// users can't overwrite each other's count.
  Future<void> recommendSkill(String userId, Skill skill) {
    final recommended = !skill.isRecommended;
    return _database.setRecommendation(userId: userId, skillId: skill.id!, recommended: recommended, delta: recommended ? 1 : -1);
  }
}
