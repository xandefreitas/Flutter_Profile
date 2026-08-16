import 'package:flutter_bloc/flutter_bloc.dart';

import '../util/error_util.dart';

/// Runs a bloc event handler body with the try/catch -> error-state pattern
/// shared by every bloc in this app: run [action], and on any exception emit
/// the domain's error state via [onError] instead of letting it propagate.
Future<void> runBlocEvent<Event, State>({
  required Event event,
  required Emitter<State> emit,
  required Future<void> Function() action,
  required State Function(dynamic exception, Event event) onError,
}) async {
  try {
    await action();
  } catch (e) {
    emit(onError(ErrorUtil.validateException(e), event));
  }
}
