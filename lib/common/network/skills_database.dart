/// Thin seam between [SkillsWebClient] and the actual Realtime Database
/// calls, so tests can substitute an in-memory fake instead of depending on
/// a firebase_database-compatible mocking package (none exists for the
/// version this app is pinned to).
abstract class SkillsDatabase {
  /// Emits the full `skills` node (id -> {title, likesQuantity}) on every
  /// change, starting with the current value.
  Stream<Map<String, dynamic>> watchSkills();

  /// One-time read of which skill ids [userId] currently recommends.
  Future<Map<String, dynamic>> getUserRecommendations(String userId);

  Future<void> addSkill(String title);

  Future<void> removeSkill(String skillId);

  /// Atomically flips the user's recommendation flag and adjusts the
  /// skill's like count by [delta] in a single multi-path update, so
  /// concurrent votes from different users can't clobber each other.
  Future<void> setRecommendation({required String userId, required String skillId, required bool recommended, required int delta});
}
