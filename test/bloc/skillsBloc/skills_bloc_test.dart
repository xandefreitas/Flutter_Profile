import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_profile/common/api/skills_webclient.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_bloc.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_event.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_state.dart';
import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSkillsWebClient extends Mock implements SkillsWebClient {}

void main() {
  late MockSkillsWebClient webClient;
  final skill = Skill(id: '1', title: 'Dart', likesQuantity: 5);

  setUpAll(() {
    registerFallbackValue(skill);
  });

  setUp(() {
    webClient = MockSkillsWebClient();
  });

  blocTest<SkillsBloc, SkillsState>(
    'emits [Fetching, Fetched] when getSkills succeeds',
    build: () {
      when(() => webClient.getSkills()).thenAnswer((_) async => [skill]);
      return SkillsBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(SkillsFetchEvent()),
    expect: () => [SkillsFetchingState(), SkillsFetchedState(skills: [skill])],
  );

  blocTest<SkillsBloc, SkillsState>(
    'emits [Fetching, Error] when getSkills throws a DioException',
    build: () {
      when(() => webClient.getSkills()).thenThrow(DioException(requestOptions: RequestOptions(path: '/x'), error: Exception('boom')));
      return SkillsBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(SkillsFetchEvent()),
    expect: () => [SkillsFetchingState(), isA<SkillsErrorState>().having((s) => s.exception, 'exception', 'Exception: boom')],
  );

  blocTest<SkillsBloc, SkillsState>(
    'emits [Updating, Updated] and calls recommendSkill with the event userId/skill',
    build: () {
      when(() => webClient.recommendSkill(any(), any())).thenAnswer((_) async => 'Recommended');
      return SkillsBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(SkillsUpdateEvent(skill: skill, userId: 'uid1')),
    expect: () => [SkillsUpdatingState(), const SkillsUpdatedState(response: 'Recommended')],
    verify: (_) {
      verify(() => webClient.recommendSkill('uid1', skill)).called(1);
    },
  );

  blocTest<SkillsBloc, SkillsState>(
    'emits [Adding, Added] when addNewSkill succeeds',
    build: () {
      when(() => webClient.addNewSkill(any())).thenAnswer((_) async => 'Created');
      return SkillsBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(const SkillsAddEvent(skillTitle: 'Dart')),
    expect: () => [SkillsAddingState(), const SkillsAddedState(response: 'Created')],
    verify: (_) {
      verify(() => webClient.addNewSkill('Dart')).called(1);
    },
  );

  blocTest<SkillsBloc, SkillsState>(
    'emits [Removing, Removed] when removeSkill succeeds',
    build: () {
      when(() => webClient.removeSkill(any())).thenAnswer((_) async => 'Deleted');
      return SkillsBloc(webClient: webClient);
    },
    act: (bloc) => bloc.add(const SkillsRemoveEvent(skillId: '1')),
    expect: () => [SkillsRemovingState(), const SkillsRemovedState(response: 'Deleted')],
  );
}
