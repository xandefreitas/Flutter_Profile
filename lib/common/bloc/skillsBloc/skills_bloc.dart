import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/api/skills_webclient.dart';

import '../../util/error_util.dart';
import 'skills_event.dart';
import 'skills_state.dart';

class SkillsBloc extends Bloc<SkillsEvent, SkillsState> {
  final SkillsWebClient skillsWebClient;
  SkillsBloc()
      : skillsWebClient = SkillsWebClient(),
        super(SkillsInitial()) {
    on<SkillsEvent>((event, emit) async {
      try {
        if (event is SkillsFetchEvent) {
          emit(SkillsFetchingState());
          final response = await skillsWebClient.getSkills();
          emit(SkillsFetchedState(skills: response));
        }
        if (event is SkillsUpdateEvent) {
          emit(SkillsUpdatingState());
          final response = await skillsWebClient.recommendSkill(event.userId, event.skill);
          emit(SkillsUpdatedState(response: response));
        }
        if (event is SkillsAddEvent) {
          emit(SkillsAddingState());
          final response = await skillsWebClient.addNewSkill(event.skillTitle);
          emit(SkillsAddedState(response: response));
        }
        if (event is SkillsRemoveEvent) {
          emit(SkillsRemovingState());
          final response = await skillsWebClient.removeSkill(event.skillId);
          emit(SkillsRemovedState(response: response));
        }
      } catch (e) {
        emit(SkillsErrorState(exception: ErrorUtil.validateException(e), event: event));
      }
    });
  }
}
