import 'package:equatable/equatable.dart';
import 'package:flutter_profile/common/models/company.dart';

abstract class WorkHistoryEvent extends Equatable {
  const WorkHistoryEvent();

  @override
  List<Object> get props => [];
}

class WorkHistoryFetchEvent extends WorkHistoryEvent {}

class WorkHistoryUpdateEvent extends WorkHistoryEvent {
  final Company company;

  const WorkHistoryUpdateEvent({required this.company});

  @override
  List<Object> get props => [company];
}

class WorkHistoryAddEvent extends WorkHistoryEvent {
  final Company company;

  const WorkHistoryAddEvent({required this.company});

  @override
  List<Object> get props => [company];
}

class WorkHistoryRemoveEvent extends WorkHistoryEvent {
  final String companyId;

  const WorkHistoryRemoveEvent({required this.companyId});

  @override
  List<Object> get props => [companyId];
}
