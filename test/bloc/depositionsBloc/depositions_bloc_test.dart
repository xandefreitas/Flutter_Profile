import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_profile/common/api/depositions_webclient.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_bloc.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_event.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_state.dart';
import 'package:flutter_profile/common/models/deposition.dart';
import 'package:flutter_profile/common/util/connectivity_util.dart';
import 'package:flutter_profile/common/util/error_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDepositionsWebClient extends Mock implements DepositionsWebClient {}

void main() {
  late MockDepositionsWebClient webClient;
  final deposition = Deposition(id: '1', uid: 'uid1', name: 'Alexandre', relationship: 1, deposition: 'text', iconIndex: 0);

  // `Stream.value(...)` delivers on a later microtask, which would race
  // against blocTest's synchronous `build()`. A sync broadcast controller
  // delivers `add()` to the already-attached listener immediately, so
  // ConnectivityUtil.isConnected reflects it before `build()` returns.
  ConnectivityUtil connectivityWith(bool connected) {
    final controller = StreamController<bool>.broadcast(sync: true);
    final connectivity = ConnectivityUtil(connectedStream: controller.stream);
    controller.add(connected);
    return connectivity;
  }

  ConnectivityUtil onlineConnectivity() => connectivityWith(true);
  ConnectivityUtil offlineConnectivity() => connectivityWith(false);

  setUpAll(() {
    registerFallbackValue(deposition);
  });

  setUp(() {
    webClient = MockDepositionsWebClient();
  });

  blocTest<DepositionsBloc, DepositionsState>(
    'emits [Fetching, Fetched] for the first value of the depositions stream',
    build: () {
      when(() => webClient.watchDepositions()).thenAnswer((_) => Stream.value([deposition]));
      return DepositionsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(DepositionsFetchEvent()),
    expect: () => [DepositionsFetchingState(), DepositionsFetchedState(depositions: [deposition])],
  );

  blocTest<DepositionsBloc, DepositionsState>(
    'emits a new Fetched state for every value the depositions stream produces afterwards',
    build: () {
      final controller = StreamController<List<Deposition>>();
      addTearDown(controller.close);
      when(() => webClient.watchDepositions()).thenAnswer((_) => controller.stream);
      controller.add([deposition]);
      final second = Deposition(id: '2', uid: 'uid2', name: 'Someone', relationship: 0, deposition: 'other', iconIndex: 1);
      Future<void>.delayed(Duration.zero, () => controller.add([deposition, second]));
      return DepositionsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(DepositionsFetchEvent()),
    expect:
        () => [
          DepositionsFetchingState(),
          DepositionsFetchedState(depositions: [deposition]),
          DepositionsFetchedState(
            depositions: [deposition, Deposition(id: '2', uid: 'uid2', name: 'Someone', relationship: 0, deposition: 'other', iconIndex: 1)],
          ),
        ],
  );

  blocTest<DepositionsBloc, DepositionsState>(
    'ignores a second DepositionsFetchEvent while already subscribed, instead of opening a duplicate subscription',
    build: () {
      when(() => webClient.watchDepositions()).thenAnswer((_) => Stream.value([deposition]));
      return DepositionsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc..add(DepositionsFetchEvent())..add(DepositionsFetchEvent()),
    expect: () => [DepositionsFetchingState(), DepositionsFetchedState(depositions: [deposition])],
    verify: (_) {
      verify(() => webClient.watchDepositions()).called(1);
    },
  );

  blocTest<DepositionsBloc, DepositionsState>(
    'emits [Fetching, Error] when the depositions stream errors',
    build: () {
      when(() => webClient.watchDepositions()).thenAnswer((_) => Stream.error(Exception('boom')));
      return DepositionsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(DepositionsFetchEvent()),
    expect:
        () => [
          DepositionsFetchingState(),
          isA<DepositionsErrorState>().having((s) => s.exception.toString(), 'exception', 'Exception: boom'),
        ],
  );

  blocTest<DepositionsBloc, DepositionsState>(
    'emits [Adding, Added] when addDeposition succeeds',
    build: () {
      when(() => webClient.addDeposition(any())).thenAnswer((_) async => deposition);
      return DepositionsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(DepositionsAddEvent(deposition: deposition)),
    expect: () => [DepositionsAddingState(), DepositionsAddedState(deposition: deposition)],
    verify: (_) {
      verify(() => webClient.addDeposition(deposition)).called(1);
    },
  );

  blocTest<DepositionsBloc, DepositionsState>(
    'emits [Updating, Updated] when updateDeposition succeeds',
    build: () {
      when(() => webClient.updateDeposition(any())).thenAnswer((_) async => deposition);
      return DepositionsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(DepositionsUpdateEvent(deposition: deposition)),
    expect: () => [DepositionsUpdatingState(), DepositionsUpdatedState(deposition: deposition)],
  );

  blocTest<DepositionsBloc, DepositionsState>(
    'emits [Removing, Removed] when removeDeposition succeeds',
    build: () {
      when(() => webClient.removeDeposition(any())).thenAnswer((_) async => '1');
      return DepositionsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(const DepositionsRemoveEvent(depositionId: '1')),
    expect: () => [DepositionsRemovingState(), const DepositionsRemovedState(depositionId: '1')],
    verify: (_) {
      verify(() => webClient.removeDeposition('1')).called(1);
    },
  );

  group('offline write-gating', () {
    blocTest<DepositionsBloc, DepositionsState>(
      'emits an offline Error and never calls addDeposition when disconnected',
      build: () => DepositionsBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(DepositionsAddEvent(deposition: deposition)),
      expect: () => [isA<DepositionsErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.addDeposition(any()));
      },
    );

    blocTest<DepositionsBloc, DepositionsState>(
      'emits an offline Error and never calls updateDeposition when disconnected',
      build: () => DepositionsBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(DepositionsUpdateEvent(deposition: deposition)),
      expect: () => [isA<DepositionsErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.updateDeposition(any()));
      },
    );

    blocTest<DepositionsBloc, DepositionsState>(
      'emits an offline Error and never calls removeDeposition when disconnected',
      build: () => DepositionsBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(const DepositionsRemoveEvent(depositionId: '1')),
      expect: () => [isA<DepositionsErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.removeDeposition(any()));
      },
    );
  });

  blocTest<DepositionsBloc, DepositionsState>(
    'maps a connection-error DioException to the offline message',
    build: () {
      when(() => webClient.addDeposition(any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.connectionError),
      );
      return DepositionsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(DepositionsAddEvent(deposition: deposition)),
    expect: () => [DepositionsAddingState(), isA<DepositionsErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
  );
}
