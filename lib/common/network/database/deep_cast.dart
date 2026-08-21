/// Recursively converts a Realtime Database value into plain JSON-like
/// shapes (`Map<String, dynamic>` / `List<dynamic>`) so model `fromMap`
/// factories can rely on consistent types regardless of how the native SDK
/// represented a given node: nested arrays can come back as either a
/// `List<Object?>` or a `Map<Object?, Object?>` keyed by string indices, and
/// object keys are never guaranteed to already be `String`.
dynamic deepCastDatabaseValue(Object? value) {
  if (value is Map) {
    return value.map((key, v) => MapEntry(key.toString(), deepCastDatabaseValue(v)));
  }
  if (value is List) {
    return value.map(deepCastDatabaseValue).toList();
  }
  return value;
}

/// [deepCastDatabaseValue], typed for the common case of a database node
/// whose value is a map (or absent).
Map<String, dynamic> deepCastDatabaseMap(Object? value) {
  final result = deepCastDatabaseValue(value);
  return result is Map<String, dynamic> ? result : <String, dynamic>{};
}
