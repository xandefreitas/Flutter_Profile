import 'package:equatable/equatable.dart';

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

class SkillsUpdatedState extends SkillsState {}

class SkillsAddingState extends SkillsLoadingState {}

class SkillsAddedState extends SkillsState {}

class SkillsRemovingState extends SkillsLoadingState {}

class SkillsRemovedState extends SkillsState {}
