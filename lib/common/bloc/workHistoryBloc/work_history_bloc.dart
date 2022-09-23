import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/bloc/workHistoryBloc/work_history_event.dart';
import 'package:flutter_profile/common/bloc/workHistoryBloc/work_history_state.dart';
import '../../api/work_history_webclient.dart';
import '../../util/error_util.dart';

class WorkHistoryBloc extends Bloc<WorkHistoryEvent, WorkHistoryState> {
  final WorkHistoryWebClient workHistoryWebClient;
  WorkHistoryBloc()
      : workHistoryWebClient = WorkHistoryWebClient(),
        super(WorkHistoryInitial()) {
    on<WorkHistoryEvent>((event, emit) async {
      try {
        if (event is WorkHistoryFetchEvent) {
          emit(WorkHistoryFetchingState());
          final response = await workHistoryWebClient.getWorkHistory();
          emit(WorkHistoryFetchedState(workHistory: response));
        }
        if (event is WorkHistoryUpdateEvent) {
          emit(WorkHistoryUpdatingState());
          final response = await workHistoryWebClient.updateWorkHistory(event.company);
          emit(WorkHistoryUpdatedState(response: response));
        }
        if (event is WorkHistoryAddEvent) {
          emit(WorkHistoryAddingState());
          final response = await workHistoryWebClient.addWorkHistory(event.company);
          emit(WorkHistoryAddedState(response: response));
        }
        if (event is WorkHistoryRemoveEvent) {
          emit(WorkHistoryRemovingState());
          final response = await workHistoryWebClient.removeWorkHistory(event.companyId);
          emit(WorkHistoryRemovedState(response: response));
        }
      } catch (e) {
        emit(WorkHistoryErrorState(exception: ErrorUtil.validateException(e), event: event));
      }
    });
  }
}
