import 'package:equatable/equatable.dart';
import 'package:flutter_profile/common/models/skill.dart';

abstract class SkillsEvent extends Equatable {
  const SkillsEvent();

  @override
  List<Object> get props => [];
}

class SkillsFetchEvent extends SkillsEvent {}

class SkillsUpdateEvent extends SkillsEvent {
  final Skill skill;
  final String userId;

  const SkillsUpdateEvent({required this.skill, required this.userId});

  @override
  List<Object> get props => [skill];
}

class SkillsAddEvent extends SkillsEvent {
  final String skillTitle;

  const SkillsAddEvent({required this.skillTitle});

  @override
  List<Object> get props => [skillTitle];
}

class SkillsRemoveEvent extends SkillsEvent {
  final String skillId;

  const SkillsRemoveEvent({required this.skillId});

  @override
  List<Object> get props => [skillId];
}
