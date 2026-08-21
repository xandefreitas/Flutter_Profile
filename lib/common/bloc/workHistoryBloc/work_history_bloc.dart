import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/work_history_webclient.dart';
import '../../models/company.dart';
import '../../util/connectivity_util.dart';
import '../../util/error_util.dart';
import 'work_history_event.dart';
import 'work_history_state.dart';

class WorkHistoryBloc extends Bloc<WorkHistoryEvent, WorkHistoryState> {
  final WorkHistoryWebClient workHistoryWebClient;
  final ConnectivityUtil connectivityUtil;

  /// Guards against subscribing to [WorkHistoryWebClient.watchWorkHistory]
  /// more than once: several widgets dispatch [WorkHistoryFetchEvent]
  /// against this same shared bloc instance, but only one live subscription
  /// should run.
  bool _isWatchingWorkHistory = false;

  WorkHistoryBloc({WorkHistoryWebClient? webClient, ConnectivityUtil? connectivityUtil})
    : workHistoryWebClient = webClient ?? WorkHistoryWebClient(),
      connectivityUtil = connectivityUtil ?? ConnectivityUtil(),
      super(WorkHistoryInitial()) {
    on<WorkHistoryFetchEvent>(_onFetch);
    on<WorkHistoryAddEvent>(_onAdd);
    on<WorkHistoryUpdateEvent>(_onUpdate);
    on<WorkHistoryRemoveEvent>(_onRemove);
  }

  Future<void> _onFetch(WorkHistoryFetchEvent event, Emitter<WorkHistoryState> emit) async {
    if (_isWatchingWorkHistory) return;
    _isWatchingWorkHistory = true;
    emit(WorkHistoryFetchingState());
    await emit.forEach<List<Company>>(
      workHistoryWebClient.watchWorkHistory(),
      onData: (workHistory) => WorkHistoryFetchedState(workHistory: workHistory),
      onError: (error, stackTrace) {
        _isWatchingWorkHistory = false;
        return WorkHistoryErrorState(exception: ErrorUtil.validateException(error), event: event);
      },
    );
  }

  Future<void> _onAdd(WorkHistoryAddEvent event, Emitter<WorkHistoryState> emit) async {
    // Writes still go over plain REST/Dio (no offline queue), so check the
    // connectivity signal up front instead of letting the call hang or fail
    // with a raw timeout.
    if (!connectivityUtil.isConnected) {
      emit(WorkHistoryErrorState(exception: ErrorUtil.offlineMessage, event: event));
      return;
    }
    emit(WorkHistoryAddingState());
    try {
      final company = await workHistoryWebClient.addWorkHistory(event.company);
      emit(WorkHistoryAddedState(company: company));
    } catch (e) {
      emit(WorkHistoryErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }

  Future<void> _onUpdate(WorkHistoryUpdateEvent event, Emitter<WorkHistoryState> emit) async {
    if (!connectivityUtil.isConnected) {
      emit(WorkHistoryErrorState(exception: ErrorUtil.offlineMessage, event: event));
      return;
    }
    emit(WorkHistoryUpdatingState());
    try {
      final company = await workHistoryWebClient.updateWorkHistory(event.company);
      emit(WorkHistoryUpdatedState(company: company));
    } catch (e) {
      emit(WorkHistoryErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }

  Future<void> _onRemove(WorkHistoryRemoveEvent event, Emitter<WorkHistoryState> emit) async {
    if (!connectivityUtil.isConnected) {
      emit(WorkHistoryErrorState(exception: ErrorUtil.offlineMessage, event: event));
      return;
    }
    emit(WorkHistoryRemovingState());
    try {
      final companyId = await workHistoryWebClient.removeWorkHistory(event.companyId);
      emit(WorkHistoryRemovedState(companyId: companyId));
    } catch (e) {
      emit(WorkHistoryErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }
}
