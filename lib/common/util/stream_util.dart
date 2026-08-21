import 'dart:async';

/// Emits a combined value whenever either source stream produces one, using
/// the latest value already seen from the other — the manual equivalent of
/// rxdart's `combineLatest2`, kept local since neither `rxdart` nor `async`
/// (whose `StreamGroup` doesn't offer combine-latest semantics) is a direct
/// dependency of this app.
Stream<R> combineLatest2<A, B, R>(Stream<A> streamA, Stream<B> streamB, R Function(A a, B b) combine) {
  late StreamController<R> controller;
  StreamSubscription<A>? subscriptionA;
  StreamSubscription<B>? subscriptionB;
  A? latestA;
  B? latestB;
  var hasA = false;
  var hasB = false;

  void emitIfReady() {
    if (hasA && hasB) {
      controller.add(combine(latestA as A, latestB as B));
    }
  }

  controller = StreamController<R>.broadcast(
    onListen: () {
      subscriptionA = streamA.listen(
        (value) {
          latestA = value;
          hasA = true;
          emitIfReady();
        },
        onError: controller.addError,
      );
      subscriptionB = streamB.listen(
        (value) {
          latestB = value;
          hasB = true;
          emitIfReady();
        },
        onError: controller.addError,
      );
    },
    onCancel: () async {
      await subscriptionA?.cancel();
      await subscriptionB?.cancel();
    },
  );
  return controller.stream;
}
