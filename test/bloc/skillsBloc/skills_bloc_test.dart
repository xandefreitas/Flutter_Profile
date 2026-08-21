import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_profile/common/api/skills_webclient.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_bloc.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_event.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_state.dart';
import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_profile/common/util/connectivity_util.dart';
import 'package:flutter_profile/common/util/error_util.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSkillsWebClient extends Mock implements SkillsWebClient {}

void main() {
  late MockSkillsWebClient webClient;
  final skill = Skill(id: '1', title: 'Dart', likesQuantity: 5);

  // `Stream.value(...)` delivers on a later microtask, which would race
  // against blocTest's synchronous `build()`. A sync broadcast controller
  // delivers `add()` to the already-attached listener immediately, so
  // ConnectivityUtil.isConnected reflects it before `build()` returns.
  ConnectivityUtil connectivityWith(bool connected) {
    final controller = StreamController<bool>.broadcast(sync: true);
    final connectivity = ConnectivityUtil(connectedStream: controller.stream);
    controller.add(connected);
    return connectivity;
  }

  ConnectivityUtil onlineConnectivity() => connectivityWith(true);
  ConnectivityUtil offlineConnectivity() => connectivityWith(false);

  setUpAll(() {
    registerFallbackValue(skill);
  });

  setUp(() {
    webClient = MockSkillsWebClient();
  });

  blocTest<SkillsBloc, SkillsState>(
    'emits [Fetching, Fetched] for the first value of the skills stream',
    build: () {
      when(() => webClient.watchSkills()).thenAnswer((_) => Stream.value([skill]));
      return SkillsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(SkillsFetchEvent()),
    expect: () => [SkillsFetchingState(), SkillsFetchedState(skills: [skill])],
  );

  blocTest<SkillsBloc, SkillsState>(
    'emits a new Fetched state for every value the skills stream produces afterwards',
    build: () {
      final controller = StreamController<List<Skill>>();
      addTearDown(controller.close);
      when(() => webClient.watchSkills()).thenAnswer((_) => controller.stream);
      controller.add([skill]);
      Future<void>.delayed(Duration.zero, () => controller.add([skill, Skill(id: '2', title: 'Flutter', likesQuantity: 1)]));
      return SkillsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(SkillsFetchEvent()),
    expect: () => [
      SkillsFetchingState(),
      SkillsFetchedState(skills: [skill]),
      SkillsFetchedState(skills: [skill, Skill(id: '2', title: 'Flutter', likesQuantity: 1)]),
    ],
  );

  blocTest<SkillsBloc, SkillsState>(
    'ignores a second SkillsFetchEvent while already subscribed, instead of opening a duplicate subscription',
    build: () {
      when(() => webClient.watchSkills()).thenAnswer((_) => Stream.value([skill]));
      return SkillsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc..add(SkillsFetchEvent())..add(SkillsFetchEvent()),
    expect: () => [SkillsFetchingState(), SkillsFetchedState(skills: [skill])],
    verify: (_) {
      verify(() => webClient.watchSkills()).called(1);
    },
  );

  blocTest<SkillsBloc, SkillsState>(
    'emits [Fetching, Error] when the skills stream errors',
    build: () {
      when(() => webClient.watchSkills()).thenAnswer((_) => Stream.error(Exception('boom')));
      return SkillsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(SkillsFetchEvent()),
    expect: () => [SkillsFetchingState(), isA<SkillsErrorState>().having((s) => s.exception.toString(), 'exception', 'Exception: boom')],
  );

  blocTest<SkillsBloc, SkillsState>(
    'emits [Updating, Updated] and calls recommendSkill with the event userId/skill',
    build: () {
      when(() => webClient.recommendSkill(any(), any())).thenAnswer((_) async {});
      return SkillsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(SkillsUpdateEvent(skill: skill, userId: 'uid1')),
    expect: () => [SkillsUpdatingState(), const SkillsUpdatedState(response: 'Updated')],
    verify: (_) {
      verify(() => webClient.recommendSkill('uid1', skill)).called(1);
    },
  );

  blocTest<SkillsBloc, SkillsState>(
    'emits [Updating, Error] when recommendSkill throws',
    build: () {
      when(() => webClient.recommendSkill(any(), any())).thenThrow(Exception('boom'));
      return SkillsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(SkillsUpdateEvent(skill: skill, userId: 'uid1')),
    expect: () => [SkillsUpdatingState(), isA<SkillsErrorState>().having((s) => s.exception.toString(), 'exception', 'Exception: boom')],
  );

  blocTest<SkillsBloc, SkillsState>(
    'emits [Adding, Added] when addNewSkill succeeds',
    build: () {
      when(() => webClient.addNewSkill(any())).thenAnswer((_) async {});
      return SkillsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
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
      when(() => webClient.removeSkill(any())).thenAnswer((_) async {});
      return SkillsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(const SkillsRemoveEvent(skillId: '1')),
    expect: () => [SkillsRemovingState(), const SkillsRemovedState(response: 'Deleted')],
  );

  group('offline write-gating', () {
    blocTest<SkillsBloc, SkillsState>(
      'emits an offline Error and never calls recommendSkill when disconnected',
      build: () => SkillsBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(SkillsUpdateEvent(skill: skill, userId: 'uid1')),
      expect: () => [isA<SkillsErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.recommendSkill(any(), any()));
      },
    );

    blocTest<SkillsBloc, SkillsState>(
      'emits an offline Error and never calls addNewSkill when disconnected',
      build: () => SkillsBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(const SkillsAddEvent(skillTitle: 'Dart')),
      expect: () => [isA<SkillsErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.addNewSkill(any()));
      },
    );

    blocTest<SkillsBloc, SkillsState>(
      'emits an offline Error and never calls removeSkill when disconnected',
      build: () => SkillsBloc(webClient: webClient, connectivityUtil: offlineConnectivity()),
      act: (bloc) => bloc.add(const SkillsRemoveEvent(skillId: '1')),
      expect: () => [isA<SkillsErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
      verify: (_) {
        verifyNever(() => webClient.removeSkill(any()));
      },
    );
  });

  blocTest<SkillsBloc, SkillsState>(
    'maps a connection-error DioException to the offline message',
    build: () {
      when(() => webClient.recommendSkill(any(), any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.connectionError),
      );
      return SkillsBloc(webClient: webClient, connectivityUtil: onlineConnectivity());
    },
    act: (bloc) => bloc.add(SkillsUpdateEvent(skill: skill, userId: 'uid1')),
    expect: () => [SkillsUpdatingState(), isA<SkillsErrorState>().having((s) => s.exception, 'exception', ErrorUtil.offlineMessage)],
  );
}
