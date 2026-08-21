/// Thin seam between [DepositionsWebClient] and the actual Realtime
/// Database calls, so tests can substitute an in-memory fake instead of
/// depending on a firebase_database-compatible mocking package (none exists
/// for the version this app is pinned to).
abstract class DepositionsDatabase {
  /// Emits the full `depositions` node (id -> deposition fields) on every
  /// change, starting with the current value.
  Stream<Map<String, dynamic>> watchDepositions();
}
