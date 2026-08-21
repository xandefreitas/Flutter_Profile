import 'dart:async';

import 'package:flutter_profile/common/network/database/skills_database.dart';

/// In-memory [SkillsDatabase] used by [SkillsWebClient] unit tests.
///
/// No firebase_database-compatible mocking package supports the version
/// this app depends on, so this fake stands in for it. It mirrors the one
/// behaviour that actually matters for the race-condition fix: like counts
/// are adjusted with `current + delta` (like Realtime Database's
/// `ServerValue.increment`), never overwritten with a caller-supplied
/// absolute value.
class FakeSkillsDatabase implements SkillsDatabase {
  final Map<String, Map<String, dynamic>> _skills = {};
  final Map<String, Map<String, bool>> _userRecommended = {};
  final StreamController<Map<String, dynamic>> _changes = StreamController.broadcast();
  Object? errorToThrow;
  int _nextId = 0;

  void seedSkill(String id, {required String title, int likesQuantity = 0}) {
    _skills[id] = {'title': title, 'likesQuantity': likesQuantity};
  }

  void seedUserRecommendation(String userId, String skillId, bool value) {
    _userRecommended.putIfAbsent(userId, () => {})[skillId] = value;
  }

  Map<String, Map<String, dynamic>> get skillsSnapshot => _skills.map((id, data) => MapEntry(id, Map<String, dynamic>.from(data)));

  @override
  Stream<Map<String, dynamic>> watchSkills() {
    if (errorToThrow != null) return Stream.error(errorToThrow!);
    return Stream.multi((controller) {
      controller.add(skillsSnapshot);
      final subscription = _changes.stream.listen(controller.add, onError: controller.addError);
      controller.onCancel = subscription.cancel;
    });
  }

  @override
  Stream<Map<String, dynamic>> watchUserRecommendations(String userId) {
    Map<String, dynamic> snapshot() => Map<String, dynamic>.from(_userRecommended[userId] ?? {});
    return Stream.multi((controller) {
      controller.add(snapshot());
      final subscription = _changes.stream.listen((_) => controller.add(snapshot()), onError: controller.addError);
      controller.onCancel = subscription.cancel;
    });
  }

  @override
  Future<void> addSkill(String title) async {
    _skills['fake_${_nextId++}'] = {'title': title, 'likesQuantity': 0};
    _changes.add(skillsSnapshot);
  }

  @override
  Future<void> removeSkill(String skillId) async {
    _skills.remove(skillId);
    _changes.add(skillsSnapshot);
  }

  @override
  Future<void> setRecommendation({required String userId, required String skillId, required bool recommended, required int delta}) async {
    _userRecommended.putIfAbsent(userId, () => {})[skillId] = recommended;
    final current = (_skills[skillId]?['likesQuantity'] as int?) ?? 0;
    _skills[skillId] = {...?_skills[skillId], 'likesQuantity': current + delta};
    _changes.add(skillsSnapshot);
  }
}
