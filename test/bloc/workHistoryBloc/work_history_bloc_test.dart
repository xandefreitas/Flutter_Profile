import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_profile/common/api/work_history_webclient.dart';
import 'package:flutter_profile/common/bloc/workHistoryBloc/work_history_bloc.dart';
import 'package:flutter_profile/common/bloc/workHistoryBloc/work_history_event.dart';
import 'package:flutter_profile/common/bloc/workHistoryBloc/work_history_state.dart';
import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/common/util/connectivity_util.dart';
import 'package:flutter_profile/common/util/error_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkHistoryWebClient extends Mock implements WorkHistoryWebClient {}

void main() {
  late MockWorkHistoryWebClient webClient;
  final company = Company(id: '1', name: 'Acme', occupations: const []);

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
    registerFallbackValue(company);
  });

  setUp(() {
    webClient = MockWorkHistoryWebClient();
  });

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'emits [Fetching, Fetched] for the first value of the work history stream',
    build: () {
      when(() => webClient.watchWorkHistory()).thenAnswer((_) => Stream.value([company]));
      return WorkHistoryBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(WorkHistoryFetchEvent()),
    expect: () => [WorkHistoryFetchingState(), WorkHistoryFetchedState(workHistory: [company])],
  );

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'emits a new Fetched state for every value the work history stream produces afterwards',
    build: () {
      final controller = StreamController<List<Company>>();
      addTearDown(controller.close);
      when(() => webClient.watchWorkHistory()).thenAnswer((_) => controller.stream);
      controller.add([company]);
      final second = Company(id: '2', name: 'Other', occupations: const []);
      Future<void>.delayed(Duration.zero, () => controller.add([company, second]));
      return WorkHistoryBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(WorkHistoryFetchEvent()),
    expect:
        () => [
          WorkHistoryFetchingState(),
          WorkHistoryFetchedState(workHistory: [company]),
          WorkHistoryFetchedState(workHistory: [company, Company(id: '2', name: 'Other', occupations: const [])]),
        ],
  );

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'ignores a second WorkHistoryFetchEvent while already subscribed, instead of opening a duplicate subscription',
    build: () {
      when(() => webClient.watchWorkHistory()).thenAnswer((_) => Stream.value([company]));
      return WorkHistoryBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc..add(WorkHistoryFetchEvent())..add(WorkHistoryFetchEvent()),
    expect: () => [WorkHistoryFetchingState(), WorkHistoryFetchedState(workHistory: [company])],
    verify: (_) {
      verify(() => webClient.watchWorkHistory()).called(1);
    },
  );

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'emits [Fetching, Error] when the work history stream errors',
    build: () {
      when(() => webClient.watchWorkHistory()).thenAnswer((_) => Stream.error(Exception('boom')));
      return WorkHistoryBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(WorkHistoryFetchEvent()),
    expect: () => [WorkHistoryFetchingState(), isA<WorkHistoryErrorState>().having((s) => s.exception.toString(), 'exception', 'Exception: boom')],
  );

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'emits [Adding, Added] when addWorkHistory succeeds',
    build: () {
      when(() => webClient.addWorkHistory(any())).thenAnswer((_) async => company);
      return WorkHistoryBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(WorkHistoryAddEvent(company: company)),
    expect: () => [WorkHistoryAddingState(), WorkHistoryAddedState(company: company)],
    verify: (_) {
      verify(() => webClient.addWorkHistory(company)).called(1);
    },
  );

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'emits [Updating, Updated] when updateWorkHistory succeeds',
    build: () {
      when(() => webClient.updateWorkHistory(any())).thenAnswer((_) async => company);
      return WorkHistoryBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(WorkHistoryUpdateEvent(company: company)),
    expect: () => [WorkHistoryUpdatingState(), WorkHistoryUpdatedState(company: company)],
  );

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'emits [Removing, Removed] when removeWorkHistory succeeds',
    build: () {
      when(() => webClient.removeWorkHistory(any())).thenAnswer((_) async => '1');
      return WorkHistoryBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(const WorkHistoryRemoveEvent(companyId: '1')),
    expect: () => [WorkHistoryRemovingState(), const WorkHistoryRemovedState(companyId: '1')],
    verify: (_) {
      verify(() => webClient.removeWorkHistory('1')).called(1);
    },
  );

  group('offline write-gating', () {
    blocTest<WorkHistoryBloc, WorkHistoryState>(
      'emits an offline Error and never calls addWorkHistory when disconnected',
      build: () => WorkHistoryBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(WorkHistoryAddEvent(company: company)),
      expect: () => [isA<WorkHistoryErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.addWorkHistory(any()));
      },
    );

    blocTest<WorkHistoryBloc, WorkHistoryState>(
      'emits an offline Error and never calls updateWorkHistory when disconnected',
      build: () => WorkHistoryBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(WorkHistoryUpdateEvent(company: company)),
      expect: () => [isA<WorkHistoryErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.updateWorkHistory(any()));
      },
    );

    blocTest<WorkHistoryBloc, WorkHistoryState>(
      'emits an offline Error and never calls removeWorkHistory when disconnected',
      build: () => WorkHistoryBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(const WorkHistoryRemoveEvent(companyId: '1')),
      expect: () => [isA<WorkHistoryErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.removeWorkHistory(any()));
      },
    );
  });

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'maps a connection-error DioException to the offline message',
    build: () {
      when(() => webClient.addWorkHistory(any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.connectionError),
      );
      return WorkHistoryBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(WorkHistoryAddEvent(company: company)),
    expect: () => [WorkHistoryAddingState(), isA<WorkHistoryErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
  );
}
