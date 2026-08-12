import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/work_history_webclient.dart';
import '../../util/error_util.dart';
import 'work_history_event.dart';
import 'work_history_state.dart';

class WorkHistoryBloc extends Bloc<WorkHistoryEvent, WorkHistoryState> {
  final WorkHistoryWebClient workHistoryWebClient;
  final Map<String, String> translationCache = {};
  WorkHistoryBloc({WorkHistoryWebClient? webClient})
    : workHistoryWebClient = webClient ?? WorkHistoryWebClient(),
      super(WorkHistoryInitial()) {
    on<WorkHistoryEvent>((event, emit) async {
      try {
        switch (event) {
          case WorkHistoryFetchEvent():
            emit(WorkHistoryFetchingState());
            final response = await workHistoryWebClient.getWorkHistory();
            emit(WorkHistoryFetchedState(workHistory: response));
          case WorkHistoryUpdateEvent():
            emit(WorkHistoryUpdatingState());
            final response = await workHistoryWebClient.updateWorkHistory(event.company);
            emit(WorkHistoryUpdatedState(response: response));
          case WorkHistoryAddEvent():
            emit(WorkHistoryAddingState());
            final response = await workHistoryWebClient.addWorkHistory(event.company);
            emit(WorkHistoryAddedState(response: response));
          case WorkHistoryRemoveEvent():
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
