/// Thin seam between [CertificatesWebClient] and the actual Realtime
/// Database calls, so tests can substitute an in-memory fake instead of
/// depending on a firebase_database-compatible mocking package (none
/// exists for the version this app is pinned to).
abstract class CertificatesDatabase {
  /// Emits the full `certificates` node (id -> fields) on every change,
  /// starting with the current value.
  Stream<Map<String, dynamic>> watchCertificates();
}
