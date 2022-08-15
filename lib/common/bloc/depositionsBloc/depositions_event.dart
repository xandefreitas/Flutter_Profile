import 'package:equatable/equatable.dart';
import 'package:flutter_profile/common/models/deposition.dart';

abstract class DepositionsEvent extends Equatable {
  const DepositionsEvent();

  @override
  List<Object> get props => [];
}

class DepositionsFetchEvent extends DepositionsEvent {}

class DepositionsUpdateEvent extends DepositionsEvent {
  final Deposition deposition;

  const DepositionsUpdateEvent({required this.deposition});

  @override
  List<Object> get props => [deposition];
}

class DepositionsAddEvent extends DepositionsEvent {
  final Deposition deposition;

  const DepositionsAddEvent({required this.deposition});

  @override
  List<Object> get props => [deposition];
}

class DepositionsRemoveEvent extends DepositionsEvent {
  final String depositionId;

  const DepositionsRemoveEvent({required this.depositionId});

  @override
  List<Object> get props => [depositionId];
}
