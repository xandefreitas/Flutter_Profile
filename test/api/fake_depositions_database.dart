import 'dart:async';

import 'package:flutter_profile/common/network/database/depositions_database.dart';

/// In-memory [DepositionsDatabase] used by [DepositionsWebClient] unit
/// tests.
///
/// No firebase_database-compatible mocking package supports the version
/// this app depends on, so this fake stands in for it.
class FakeDepositionsDatabase implements DepositionsDatabase {
  final Map<String, Map<String, dynamic>> _depositions = {};
  final StreamController<Map<String, dynamic>> _changes = StreamController.broadcast();
  Object? errorToThrow;

  void seedDeposition(String id, Map<String, dynamic> data) {
    _depositions[id] = data;
  }

  Map<String, Map<String, dynamic>> get depositionsSnapshot => _depositions.map((id, data) => MapEntry(id, Map<String, dynamic>.from(data)));

  @override
  Stream<Map<String, dynamic>> watchDepositions() {
    if (errorToThrow != null) return Stream.error(errorToThrow!);
    return Stream.multi((controller) {
      controller.add(depositionsSnapshot);
      final subscription = _changes.stream.listen(controller.add, onError: controller.addError);
      controller.onCancel = subscription.cancel;
    });
  }

  void emitChange() => _changes.add(depositionsSnapshot);
}
