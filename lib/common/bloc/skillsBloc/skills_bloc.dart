import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/api/skills_webclient.dart';

import 'skills_event.dart';
import 'skills_state.dart';

class SkillsBloc extends Bloc<SkillsEvent, SkillsState> {
  final SkillsWebClient skillsWebClient;
  SkillsBloc()
      : skillsWebClient = SkillsWebClient(),
        super(SkillsInitial()) {
    on<SkillsEvent>((event, emit) async {
      if (event is SkillsFetchEvent) {
        emit(SkillsFetchingState());
        final response = await skillsWebClient.getSkills();
        emit(SkillsFetchedState(skills: response));
      }
      if (event is SkillsUpdateEvent) {
        emit(SkillsUpdatingState());
        await skillsWebClient.recommendSkill(event.userId, event.skill);
        emit(SkillsUpdatedState());
      }
      if (event is SkillsAddEvent) {
        emit(SkillsAddingState());
        await skillsWebClient.addNewSkill(event.skillTitle);
        emit(SkillsAddedState());
      }
      if (event is SkillsRemoveEvent) {
        emit(SkillsRemovingState());
        await skillsWebClient.removeSkill(event.skillId);
        emit(SkillsRemovedState());
      }
    });
  }
}
