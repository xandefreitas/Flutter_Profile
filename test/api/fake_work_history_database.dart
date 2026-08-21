import 'dart:async';

import 'package:flutter_profile/common/network/database/work_history_database.dart';

/// In-memory [WorkHistoryDatabase] used by [WorkHistoryWebClient] unit
/// tests.
///
/// No firebase_database-compatible mocking package supports the version
/// this app depends on, so this fake stands in for it.
class FakeWorkHistoryDatabase implements WorkHistoryDatabase {
  final Map<String, Map<String, dynamic>> _companies = {};
  final StreamController<Map<String, dynamic>> _changes = StreamController.broadcast();
  Object? errorToThrow;

  void seedCompany(String id, Map<String, dynamic> data) {
    _companies[id] = data;
  }

  Map<String, Map<String, dynamic>> get companiesSnapshot => _companies.map((id, data) => MapEntry(id, Map<String, dynamic>.from(data)));

  @override
  Stream<Map<String, dynamic>> watchWorkHistory() {
    if (errorToThrow != null) return Stream.error(errorToThrow!);
    return Stream.multi((controller) {
      controller.add(companiesSnapshot);
      final subscription = _changes.stream.listen(controller.add, onError: controller.addError);
      controller.onCancel = subscription.cancel;
    });
  }

  void emitChange() => _changes.add(companiesSnapshot);
}
