import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/depositions_webclient.dart';
import '../../util/error_util.dart';
import 'depositions_event.dart';
import 'depositions_state.dart';

class DepositionsBloc extends Bloc<DepositionsEvent, DepositionsState> {
  final DepositionsWebClient depositionsWebClient;
  final Map<String, String> translationCache = {};
  DepositionsBloc() : depositionsWebClient = DepositionsWebClient(), super(DepositionsInitial()) {
    on<DepositionsEvent>((event, emit) async {
      try {
        switch (event) {
          case DepositionsFetchEvent():
            emit(DepositionsFetchingState());
            final response = await depositionsWebClient.getDepositions();
            emit(DepositionsFetchedState(depositions: response));
          case DepositionsUpdateEvent():
            emit(DepositionsUpdatingState());
            final response = await depositionsWebClient.updateDeposition(event.deposition);
            emit(DepositionsUpdatedState(response: response));
          case DepositionsAddEvent():
            emit(DepositionsAddingState());
            final response = await depositionsWebClient.addDeposition(event.deposition);
            emit(DepositionsAddedState(response: response));
          case DepositionsRemoveEvent():
            emit(DepositionsRemovingState());
            final response = await depositionsWebClient.removeDeposition(event.depositionId);
            emit(DepositionsRemovedState(response: response));
        }
      } catch (e) {
        emit(DepositionsErrorState(exception: ErrorUtil.validateException(e), event: event));
      }
    });
  }
}
