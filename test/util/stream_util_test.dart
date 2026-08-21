import 'dart:async';

import 'package:flutter_profile/common/util/stream_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('combineLatest2', () {
    test('waits for both sources to have emitted before producing a value', () async {
      final controllerA = StreamController<int>();
      final controllerB = StreamController<String>();
      addTearDown(controllerA.close);
      addTearDown(controllerB.close);
      final emissions = <String>[];
      final subscription = combineLatest2(controllerA.stream, controllerB.stream, (a, b) => '$a-$b').listen(emissions.add);

      controllerA.add(1);
      await Future<void>.delayed(Duration.zero);
      expect(emissions, isEmpty);

      controllerB.add('a');
      await Future<void>.delayed(Duration.zero);
      expect(emissions, ['1-a']);

      await subscription.cancel();
    });

    test('re-emits with the latest value from the other source whenever either one changes', () async {
      final controllerA = StreamController<int>();
      final controllerB = StreamController<String>();
      addTearDown(controllerA.close);
      addTearDown(controllerB.close);
      final emissions = <String>[];
      final subscription = combineLatest2(controllerA.stream, controllerB.stream, (a, b) => '$a-$b').listen(emissions.add);

      controllerA.add(1);
      controllerB.add('a');
      await Future<void>.delayed(Duration.zero);
      controllerB.add('b');
      await Future<void>.delayed(Duration.zero);
      controllerA.add(2);
      await Future<void>.delayed(Duration.zero);

      expect(emissions, ['1-a', '1-b', '2-b']);

      await subscription.cancel();
    });

    test('forwards an error from either source', () async {
      final controllerA = StreamController<int>();
      final controllerB = StreamController<String>();
      addTearDown(controllerA.close);
      addTearDown(controllerB.close);
      final errors = <Object>[];
      final subscription = combineLatest2(controllerA.stream, controllerB.stream, (a, b) => '$a-$b').listen((_) {}, onError: errors.add);

      controllerA.addError(Exception('boom'));
      await Future<void>.delayed(Duration.zero);

      expect(errors, [isA<Exception>()]);

      await subscription.cancel();
    });
  });
}
