/// Thin seam between [SkillsWebClient] and the actual Realtime Database
/// calls, so tests can substitute an in-memory fake instead of depending on
/// a firebase_database-compatible mocking package (none exists for the
/// version this app is pinned to).
abstract class SkillsDatabase {
  /// Emits the full `skills` node (id -> {title, likesQuantity}) on every
  /// change, starting with the current value.
  Stream<Map<String, dynamic>> watchSkills();

  /// Emits which skill ids [userId] currently recommends (id -> true) on
  /// every change, starting with the current value. A stream rather than a
  /// one-time get(), so a cached value is available immediately while
  /// offline instead of blocking on — or failing — a network round-trip.
  Stream<Map<String, dynamic>> watchUserRecommendations(String userId);

  Future<void> addSkill(String title);

  Future<void> removeSkill(String skillId);

  /// Atomically flips the user's recommendation flag and adjusts the
  /// skill's like count by [delta] in a single multi-path update, so
  /// concurrent votes from different users can't clobber each other.
  Future<void> setRecommendation({required String userId, required String skillId, required bool recommended, required int delta});
}
