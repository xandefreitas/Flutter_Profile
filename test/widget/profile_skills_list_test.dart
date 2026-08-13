import 'package:bloc_test/bloc_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/api/auth_webclient.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_bloc.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_event.dart';
import 'package:flutter_profile/common/bloc/skillsBloc/skills_state.dart';
import 'package:flutter_profile/common/enums/user_role.dart';
import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_profile/l10n/app_localizations.dart';
import 'package:flutter_profile/screens/ProfileScreen/components/profile_skills_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSkillsBloc extends MockBloc<SkillsEvent, SkillsState> implements SkillsBloc {}

Future<MockSkillsBloc> pumpList(
  WidgetTester tester, {
  required MockFirebaseAuth auth,
  required FakeFirebaseFirestore firestore,
  SkillsState? emittedState,
}) async {
  final bloc = MockSkillsBloc();
  final stream = emittedState == null ? const Stream<SkillsState>.empty() : Stream.value(emittedState);
  whenListen(bloc, stream, initialState: SkillsInitial());
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<SkillsBloc>.value(
        value: bloc,
        child: Scaffold(
          body: ProfileSkillsList(auth: auth, authWebclient: AuthWebclient(auth: auth, firestore: firestore)),
        ),
      ),
    ),
  );
  return bloc;
}

void main() {
  setUpAll(() {
    registerFallbackValue(SkillsFetchEvent());
  });

  testWidgets('dispatches SkillsFetchEvent on load', (tester) async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1', isAnonymous: true));
    final bloc = await pumpList(tester, auth: auth, firestore: FakeFirebaseFirestore());
    await tester.pumpAndSettle();

    verify(() => bloc.add(SkillsFetchEvent())).called(1);
  });

  testWidgets('renders skills once SkillsFetchedState arrives, without the add-skill chip for a non-admin', (tester) async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1', isAnonymous: true));
    final skills = [Skill(id: '1', title: 'Dart', likesQuantity: 3), Skill(id: '2', title: 'Flutter', likesQuantity: 5)];
    await pumpList(tester, auth: auth, firestore: FakeFirebaseFirestore(), emittedState: SkillsFetchedState(skills: skills));
    // The first skill chip runs an unbounded repeating animation, so
    // pumpAndSettle() would never finish — pump a couple of frames instead.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Dart'), findsOneWidget);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('+'), findsNothing);
  });

  testWidgets('shows the add-skill chip once getUserRole resolves to admin', (tester) async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1', isAnonymous: false));
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('users').doc('uid1').set({'roleValue': UserRole.ADMIN.value});
    await pumpList(
      tester,
      auth: auth,
      firestore: firestore,
      emittedState: SkillsFetchedState(skills: [Skill(id: '1', title: 'Dart', likesQuantity: 3)]),
    );
    // Same unbounded-animation caveat as above.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('+'), findsOneWidget);
  });
}
