/// Thin seam between [WorkHistoryWebClient] and the actual Realtime
/// Database calls, so tests can substitute an in-memory fake instead of
/// depending on a firebase_database-compatible mocking package (none
/// exists for the version this app is pinned to).
abstract class WorkHistoryDatabase {
  /// Emits the full `workHistory` node (id -> fields) on every change,
  /// starting with the current value.
  Stream<Map<String, dynamic>> watchWorkHistory();
}
