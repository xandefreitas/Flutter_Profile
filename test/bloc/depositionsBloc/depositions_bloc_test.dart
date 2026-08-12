import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_profile/common/api/depositions_webclient.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_bloc.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_event.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_state.dart';
import 'package:flutter_profile/common/models/deposition.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDepositionsWebClient extends Mock implements DepositionsWebClient {}

void main() {
  late MockDepositionsWebClient webClient;
  final deposition = Deposition(id: '1', uid: 'uid1', name: 'Alexandre', relationship: 1, deposition: 'text', iconIndex: 0);

  setUpAll(() {
    registerFallbackValue(deposition);
  });

  setUp(() {
    webClient = MockDepositionsWebClient();
  });

  blocTest<DepositionsBloc, DepositionsState>(
    'emits [Fetching, Fetched] when getDepositions succeeds',
    build: () {
      when(() => webClient.getDepositions()).thenAnswer((_) async => [deposition]);
      return DepositionsBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(DepositionsFetchEvent()),
    expect: () => [DepositionsFetchingState(), DepositionsFetchedState(depositions: [deposition])],
  );

  blocTest<DepositionsBloc, DepositionsState>(
    'emits [Fetching, Error] when getDepositions throws a DioException',
    build: () {
      when(() => webClient.getDepositions()).thenThrow(DioException(requestOptions: RequestOptions(path: '/x'), error: Exception('boom')));
      return DepositionsBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(DepositionsFetchEvent()),
    expect: () => [DepositionsFetchingState(), isA<DepositionsErrorState>().having((s) => s.exception, 'exception', 'Exception: boom')],
  );

  blocTest<DepositionsBloc, DepositionsState>(
    'emits [Adding, Added] when addDeposition succeeds',
    build: () {
      when(() => webClient.addDeposition(any())).thenAnswer((_) async => 'Created');
      return DepositionsBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(DepositionsAddEvent(deposition: deposition)),
    expect: () => [DepositionsAddingState(), const DepositionsAddedState(response: 'Created')],
    verify: (_) {
      verify(() => webClient.addDeposition(deposition)).called(1);
    },
  );

  blocTest<DepositionsBloc, DepositionsState>(
    'emits [Updating, Updated] when updateDeposition succeeds',
    build: () {
      when(() => webClient.updateDeposition(any())).thenAnswer((_) async => 'Updated');
      return DepositionsBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(DepositionsUpdateEvent(deposition: deposition)),
    expect: () => [DepositionsUpdatingState(), const DepositionsUpdatedState(response: 'Updated')],
  );

  blocTest<DepositionsBloc, DepositionsState>(
    'emits [Removing, Removed] when removeDeposition succeeds',
    build: () {
      when(() => webClient.removeDeposition(any())).thenAnswer((_) async => 'Deleted');
      return DepositionsBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(const DepositionsRemoveEvent(depositionId: '1')),
    expect: () => [DepositionsRemovingState(), const DepositionsRemovedState(response: 'Deleted')],
    verify: (_) {
      verify(() => webClient.removeDeposition('1')).called(1);
    },
  );
}
