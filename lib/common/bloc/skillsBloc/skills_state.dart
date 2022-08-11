import 'package:equatable/equatable.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_event.dart';

import '../../models/skill.dart';

abstract class SkillsState extends Equatable {
  const SkillsState();

  @override
  List<Object> get props => [];
}

abstract class SkillsLoadingState extends SkillsState {}

class SkillsInitial extends SkillsState {}

class SkillsFetchingState extends SkillsLoadingState {}

class SkillsFetchedState extends SkillsState {
  final List<Skill> skills;

  const SkillsFetchedState({required this.skills});

  @override
  List<Object> get props => [skills];
}

class SkillsUpdatingState extends SkillsLoadingState {}

class SkillsUpdatedState extends SkillsState {
  final String response;

  const SkillsUpdatedState({required this.response});

  @override
  List<Object> get props => [response];
}

class SkillsAddingState extends SkillsLoadingState {}

class SkillsAddedState extends SkillsState {
  final String response;

  const SkillsAddedState({required this.response});

  @override
  List<Object> get props => [response];
}

class SkillsRemovingState extends SkillsLoadingState {}

class SkillsRemovedState extends SkillsState {
  final String response;

  const SkillsRemovedState({required this.response});

  @override
  List<Object> get props => [response];
}

class SkillsErrorState extends SkillsState {
  final dynamic exception;
  final SkillsEvent event;

  const SkillsErrorState({required this.exception, required this.event});

  @override
  List<Object> get props => [exception, event];
}
