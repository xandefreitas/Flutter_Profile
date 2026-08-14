import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/skills_webclient.dart';
import '../../models/skill.dart';

import '../../util/error_util.dart';
import 'skills_event.dart';
import 'skills_state.dart';

class SkillsBloc extends Bloc<SkillsEvent, SkillsState> {
  final SkillsWebClient skillsWebClient;

  /// Guards against subscribing to [SkillsWebClient.watchSkills] more than
  /// once: several widgets dispatch [SkillsFetchEvent] against this same
  /// shared bloc instance, but only one live subscription should run.
  bool _isWatchingSkills = false;

  SkillsBloc({SkillsWebClient? webClient}) : skillsWebClient = webClient ?? SkillsWebClient(), super(SkillsInitial()) {
    on<SkillsFetchEvent>(_onFetch);
    on<SkillsUpdateEvent>(_onUpdate);
    on<SkillsAddEvent>(_onAdd);
    on<SkillsRemoveEvent>(_onRemove);
  }

  Future<void> _onFetch(SkillsFetchEvent event, Emitter<SkillsState> emit) async {
    if (_isWatchingSkills) return;
    _isWatchingSkills = true;
    emit(SkillsFetchingState());
    await emit.forEach<List<Skill>>(
      skillsWebClient.watchSkills(),
      onData: (skills) => SkillsFetchedState(skills: skills),
      onError: (error, stackTrace) {
        _isWatchingSkills = false;
        return SkillsErrorState(exception: ErrorUtil.validateException(error), event: event);
      },
    );
  }

  Future<void> _onUpdate(SkillsUpdateEvent event, Emitter<SkillsState> emit) async {
    emit(SkillsUpdatingState());
    try {
      await skillsWebClient.recommendSkill(event.userId, event.skill);
      emit(const SkillsUpdatedState(response: 'Updated'));
    } catch (e) {
      emit(SkillsErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }

  Future<void> _onAdd(SkillsAddEvent event, Emitter<SkillsState> emit) async {
    emit(SkillsAddingState());
    try {
      await skillsWebClient.addNewSkill(event.skillTitle);
      emit(const SkillsAddedState(response: 'Created'));
    } catch (e) {
      emit(SkillsErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }

  Future<void> _onRemove(SkillsRemoveEvent event, Emitter<SkillsState> emit) async {
    emit(SkillsRemovingState());
    try {
      await skillsWebClient.removeSkill(event.skillId);
      emit(const SkillsRemovedState(response: 'Deleted'));
    } catch (e) {
      emit(SkillsErrorState(exception: ErrorUtil.validateException(e), event: event));
    }
  }
}
