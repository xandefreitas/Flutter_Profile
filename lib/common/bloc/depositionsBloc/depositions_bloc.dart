import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/depositions_webclient.dart';
import '../bloc_error_handling.dart';
import 'depositions_event.dart';
import 'depositions_state.dart';

class DepositionsBloc extends Bloc<DepositionsEvent, DepositionsState> {
  final DepositionsWebClient depositionsWebClient;
  DepositionsBloc({DepositionsWebClient? webClient})
    : depositionsWebClient = webClient ?? DepositionsWebClient(),
      super(DepositionsInitial()) {
    on<DepositionsEvent>(
      (event, emit) => runBlocEvent(
        event: event,
        emit: emit,
        onError: (exception, event) => DepositionsErrorState(exception: exception, event: event),
        action: () async {
          switch (event) {
            case DepositionsFetchEvent():
              emit(DepositionsFetchingState());
              final response = await depositionsWebClient.getDepositions();
              emit(DepositionsFetchedState(depositions: response));
            case DepositionsUpdateEvent():
              emit(DepositionsUpdatingState());
              final deposition = await depositionsWebClient.updateDeposition(event.deposition);
              emit(DepositionsUpdatedState(deposition: deposition));
            case DepositionsAddEvent():
              emit(DepositionsAddingState());
              final deposition = await depositionsWebClient.addDeposition(event.deposition);
              emit(DepositionsAddedState(deposition: deposition));
            case DepositionsRemoveEvent():
              emit(DepositionsRemovingState());
              final depositionId = await depositionsWebClient.removeDeposition(event.depositionId);
              emit(DepositionsRemovedState(depositionId: depositionId));
          }
        },
      ),
    );
  }
}
