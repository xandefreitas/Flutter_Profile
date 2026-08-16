import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_profile/common/api/work_history_webclient.dart';
import 'package:flutter_profile/common/bloc/workHistoryBloc/work_history_bloc.dart';
import 'package:flutter_profile/common/bloc/workHistoryBloc/work_history_event.dart';
import 'package:flutter_profile/common/bloc/workHistoryBloc/work_history_state.dart';
import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkHistoryWebClient extends Mock implements WorkHistoryWebClient {}

void main() {
  late MockWorkHistoryWebClient webClient;
  final company = Company(id: '1', name: 'Acme', occupations: const []);

  setUpAll(() {
    registerFallbackValue(company);
  });

  setUp(() {
    webClient = MockWorkHistoryWebClient();
  });

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'emits [Fetching, Fetched] when getWorkHistory succeeds',
    build: () {
      when(() => webClient.getWorkHistory()).thenAnswer((_) async => [company]);
      return WorkHistoryBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(WorkHistoryFetchEvent()),
    expect: () => [WorkHistoryFetchingState(), WorkHistoryFetchedState(workHistory: [company])],
  );

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'emits [Fetching, Error] when getWorkHistory throws a DioException',
    build: () {
      when(() => webClient.getWorkHistory()).thenThrow(DioException(requestOptions: RequestOptions(path: '/x'), error: Exception('boom')));
      return WorkHistoryBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(WorkHistoryFetchEvent()),
    expect: () => [WorkHistoryFetchingState(), isA<WorkHistoryErrorState>().having((s) => s.exception, 'exception', 'Exception: boom')],
  );

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'emits [Adding, Added] when addWorkHistory succeeds',
    build: () {
      when(() => webClient.addWorkHistory(any())).thenAnswer((_) async => company);
      return WorkHistoryBloc(webClient: webClient);
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
      return WorkHistoryBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(WorkHistoryUpdateEvent(company: company)),
    expect: () => [WorkHistoryUpdatingState(), WorkHistoryUpdatedState(company: company)],
  );

  blocTest<WorkHistoryBloc, WorkHistoryState>(
    'emits [Removing, Removed] when removeWorkHistory succeeds',
    build: () {
      when(() => webClient.removeWorkHistory(any())).thenAnswer((_) async => '1');
      return WorkHistoryBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(const WorkHistoryRemoveEvent(companyId: '1')),
    expect: () => [WorkHistoryRemovingState(), const WorkHistoryRemovedState(companyId: '1')],
    verify: (_) {
      verify(() => webClient.removeWorkHistory('1')).called(1);
    },
  );
}
