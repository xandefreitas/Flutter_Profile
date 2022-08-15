import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/depositions_webclient.dart';
import '../../util/error_util.dart';
import 'depositions_event.dart';
import 'depositions_state.dart';

class DepositionsBloc extends Bloc<DepositionsEvent, DepositionsState> {
  final DepositionsWebClient depositionsWebClient;
  DepositionsBloc()
      : depositionsWebClient = DepositionsWebClient(),
        super(DepositionsInitial()) {
    on<DepositionsEvent>((event, emit) async {
      try {
        if (event is DepositionsFetchEvent) {
          emit(DepositionsFetchingState());
          final response = await depositionsWebClient.getDepositions();
          emit(DepositionsFetchedState(depositions: response));
        }
        if (event is DepositionsUpdateEvent) {
          emit(DepositionsUpdatingState());
          final response = await depositionsWebClient.updateDeposition(event.deposition);
          emit(DepositionsUpdatedState(response: response));
        }
        if (event is DepositionsAddEvent) {
          emit(DepositionsAddingState());
          final response = await depositionsWebClient.addDeposition(event.deposition);
          emit(DepositionsAddedState(response: response));
        }
        if (event is DepositionsRemoveEvent) {
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
