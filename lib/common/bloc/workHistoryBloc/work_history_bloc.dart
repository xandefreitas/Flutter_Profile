import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/work_history_webclient.dart';
import '../bloc_error_handling.dart';
import 'work_history_event.dart';
import 'work_history_state.dart';

class WorkHistoryBloc extends Bloc<WorkHistoryEvent, WorkHistoryState> {
  final WorkHistoryWebClient workHistoryWebClient;
  WorkHistoryBloc({WorkHistoryWebClient? webClient})
    : workHistoryWebClient = webClient ?? WorkHistoryWebClient(),
      super(WorkHistoryInitial()) {
    on<WorkHistoryEvent>(
      (event, emit) => runBlocEvent(
        event: event,
        emit: emit,
        onError: (exception, event) => WorkHistoryErrorState(exception: exception, event: event),
        action: () async {
          switch (event) {
            case WorkHistoryFetchEvent():
              emit(WorkHistoryFetchingState());
              final response = await workHistoryWebClient.getWorkHistory();
              emit(WorkHistoryFetchedState(workHistory: response));
            case WorkHistoryUpdateEvent():
              emit(WorkHistoryUpdatingState());
              final company = await workHistoryWebClient.updateWorkHistory(event.company);
              emit(WorkHistoryUpdatedState(company: company));
            case WorkHistoryAddEvent():
              emit(WorkHistoryAddingState());
              final company = await workHistoryWebClient.addWorkHistory(event.company);
              emit(WorkHistoryAddedState(company: company));
            case WorkHistoryRemoveEvent():
              emit(WorkHistoryRemovingState());
              final companyId = await workHistoryWebClient.removeWorkHistory(event.companyId);
              emit(WorkHistoryRemovedState(companyId: companyId));
          }
        },
      ),
    );
  }
}
