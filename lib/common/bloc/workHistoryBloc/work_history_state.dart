import 'package:equatable/equatable.dart';
import 'package:flutter_profile/common/bloc/workHistoryBloc/work_history_event.dart';

import '../../models/company.dart';

abstract class WorkHistoryState extends Equatable {
  const WorkHistoryState();

  @override
  List<Object> get props => [];
}

abstract class WorkHistoryLoadingState extends WorkHistoryState {}

class WorkHistoryInitial extends WorkHistoryState {}

class WorkHistoryFetchingState extends WorkHistoryLoadingState {}

class WorkHistoryFetchedState extends WorkHistoryState {
  final List<Company> workHistory;

  const WorkHistoryFetchedState({required this.workHistory});

  @override
  List<Object> get props => [workHistory];
}

class WorkHistoryAddingState extends WorkHistoryLoadingState {}

class WorkHistoryAddedState extends WorkHistoryState {
  final String response;

  const WorkHistoryAddedState({required this.response});

  @override
  List<Object> get props => [response];
}

class WorkHistoryUpdatingState extends WorkHistoryLoadingState {}

class WorkHistoryUpdatedState extends WorkHistoryState {
  final String response;

  const WorkHistoryUpdatedState({required this.response});

  @override
  List<Object> get props => [response];
}

class WorkHistoryRemovingState extends WorkHistoryLoadingState {}

class WorkHistoryRemovedState extends WorkHistoryState {
  final String response;

  const WorkHistoryRemovedState({required this.response});

  @override
  List<Object> get props => [response];
}

class WorkHistoryErrorState extends WorkHistoryState {
  final dynamic exception;
  final WorkHistoryEvent event;

  const WorkHistoryErrorState({required this.exception, required this.event});

  @override
  List<Object> get props => [exception, event];
}
