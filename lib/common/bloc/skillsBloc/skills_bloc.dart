import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/skills_webclient.dart';

import '../../util/error_util.dart';
import 'skills_event.dart';
import 'skills_state.dart';

class SkillsBloc extends Bloc<SkillsEvent, SkillsState> {
  final SkillsWebClient skillsWebClient;
  SkillsBloc({SkillsWebClient? webClient}) : skillsWebClient = webClient ?? SkillsWebClient(), super(SkillsInitial()) {
    on<SkillsEvent>((event, emit) async {
      try {
        switch (event) {
          case SkillsFetchEvent():
            emit(SkillsFetchingState());
            final response = await skillsWebClient.getSkills();
            emit(SkillsFetchedState(skills: response));
          case SkillsUpdateEvent():
            emit(SkillsUpdatingState());
            final response = await skillsWebClient.recommendSkill(event.userId, event.skill);
            emit(SkillsUpdatedState(response: response));
          case SkillsAddEvent():
            emit(SkillsAddingState());
            final response = await skillsWebClient.addNewSkill(event.skillTitle);
            emit(SkillsAddedState(response: response));
          case SkillsRemoveEvent():
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
