import 'package:equatable/equatable.dart';
import '../../models/deposition.dart';

import 'depositions_event.dart';

abstract class DepositionsState extends Equatable {
  const DepositionsState();

  @override
  List<Object> get props => [];
}

abstract class DepositionsLoadingState extends DepositionsState {}

class DepositionsInitial extends DepositionsState {}

class DepositionsFetchingState extends DepositionsLoadingState {}

class DepositionsFetchedState extends DepositionsState {
  final List<Deposition> depositions;

  const DepositionsFetchedState({required this.depositions});

  @override
  List<Object> get props => [depositions];
}

class DepositionsAddingState extends DepositionsLoadingState {}

class DepositionsAddedState extends DepositionsState {
  final Deposition deposition;

  const DepositionsAddedState({required this.deposition});

  @override
  List<Object> get props => [deposition];
}

class DepositionsUpdatingState extends DepositionsLoadingState {}

class DepositionsUpdatedState extends DepositionsState {
  final Deposition deposition;

  const DepositionsUpdatedState({required this.deposition});

  @override
  List<Object> get props => [deposition];
}

class DepositionsRemovingState extends DepositionsLoadingState {}

class DepositionsRemovedState extends DepositionsState {
  final String depositionId;

  const DepositionsRemovedState({required this.depositionId});

  @override
  List<Object> get props => [depositionId];
}

class DepositionsErrorState extends DepositionsState {
  final dynamic exception;
  final DepositionsEvent event;

  const DepositionsErrorState({required this.exception, required this.event});

  @override
  List<Object> get props => [exception, event];
}
