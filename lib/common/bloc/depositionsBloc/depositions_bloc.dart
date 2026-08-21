import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/depositions_webclient.dart';
import '../../models/deposition.dart';
import '../../util/error_util.dart';
import 'depositions_event.dart';
import 'depositions_state.dart';

class DepositionsBloc extends Bloc<DepositionsEvent, DepositionsState> {
  final DepositionsWebClient depositionsWebClient;

  /// Guards against subscribing to [DepositionsWebClient.watchDepositions]
  /// more than once: several widgets dispatch [DepositionsFetchEvent]
  /// against this same shared bloc instance, but only one live subscription
  /// should run.
  bool _isWatchingDepositions = false;

  DepositionsBloc({DepositionsWebClient? webClient}) : depositionsWebClient = webClient ?? DepositionsWebClient(), super(DepositionsInitial()) {
    on<DepositionsFetchEvent>(_onFetch);
    on<DepositionsUpdateEvent>(_onUpdate);
    on<DepositionsAddEvent>(_onAdd);
    on<DepositionsRemoveEvent>(_onRemove);
  }

  Future<void> _onFetch(DepositionsFetchEvent event, Emitter<DepositionsState> emit) async {
    if (_isWatchingDepositions) return;
    _isWatchingDepositions = true;
    emit(DepositionsFetchingState());
    await emit.forEach<List<Deposition>>(
      depositionsWebClient.watchDepositions(),
      onData: (depositions) => DepositionsFetchedState(depositions: depositions),
      onError: (error, stackTrace) {
        _isWatchingDepositions = false;
        return DepositionsErrorState(exception: ErrorUtil.validateException(error), event: event);
      },
    );
  }

  Future<void> _onUpdate(DepositionsUpdateEvent event, Emitter<DepositionsState> emit) async {
    emit(DepositionsUpdatingState());
    try {
      final deposition = await depositionsWebClient.updateDeposition(event.deposition);
      emit(DepositionsUpdatedState(deposition: deposition));
    } catch (e) {
      emit(DepositionsErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }

  Future<void> _onAdd(DepositionsAddEvent event, Emitter<DepositionsState> emit) async {
    emit(DepositionsAddingState());
    try {
      final deposition = await depositionsWebClient.addDeposition(event.deposition);
      emit(DepositionsAddedState(deposition: deposition));
    } catch (e) {
      emit(DepositionsErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }

  Future<void> _onRemove(DepositionsRemoveEvent event, Emitter<DepositionsState> emit) async {
    emit(DepositionsRemovingState());
    try {
      final depositionId = await depositionsWebClient.removeDeposition(event.depositionId);
      emit(DepositionsRemovedState(depositionId: depositionId));
    } catch (e) {
      emit(DepositionsErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }
}
