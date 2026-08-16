import 'package:equatable/equatable.dart';

import '../../models/company.dart';
import 'work_history_event.dart';

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
  final Company company;

  const WorkHistoryAddedState({required this.company});

  @override
  List<Object> get props => [company];
}

class WorkHistoryUpdatingState extends WorkHistoryLoadingState {}

class WorkHistoryUpdatedState extends WorkHistoryState {
  final Company company;

  const WorkHistoryUpdatedState({required this.company});

  @override
  List<Object> get props => [company];
}

class WorkHistoryRemovingState extends WorkHistoryLoadingState {}

class WorkHistoryRemovedState extends WorkHistoryState {
  final String companyId;

  const WorkHistoryRemovedState({required this.companyId});

  @override
  List<Object> get props => [companyId];
}

class WorkHistoryErrorState extends WorkHistoryState {
  final dynamic exception;
  final WorkHistoryEvent event;

  const WorkHistoryErrorState({required this.exception, required this.event});

  @override
  List<Object> get props => [exception, event];
}
