import 'dart:async';

import 'package:flutter_profile/common/util/connectivity_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('isConnected defaults to true before the first event arrives', () {
    final controller = StreamController<bool>();
    addTearDown(controller.close);
    final connectivity = ConnectivityUtil(connectedStream: controller.stream);
    addTearDown(connectivity.dispose);

    expect(connectivity.isConnected, true);
  });

  test('isConnected reflects the latest value emitted by the stream', () async {
    final controller = StreamController<bool>();
    addTearDown(controller.close);
    final connectivity = ConnectivityUtil(connectedStream: controller.stream);
    addTearDown(connectivity.dispose);

    controller.add(false);
    await Future<void>.delayed(Duration.zero);
    expect(connectivity.isConnected, false);

    controller.add(true);
    await Future<void>.delayed(Duration.zero);
    expect(connectivity.isConnected, true);
  });

  test('watchConnected re-emits every value from the underlying stream', () async {
    final controller = StreamController<bool>();
    addTearDown(controller.close);
    final connectivity = ConnectivityUtil(connectedStream: controller.stream);
    addTearDown(connectivity.dispose);
    final emissions = <bool>[];
    final subscription = connectivity.watchConnected().listen(emissions.add);
    addTearDown(subscription.cancel);

    controller
      ..add(false)
      ..add(true);
    await Future<void>.delayed(Duration.zero);

    expect(emissions, [false, true]);
  });
}
