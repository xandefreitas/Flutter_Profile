import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_bloc.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_event.dart';
import 'package:flutter_profile/common/bloc/depositionsBloc/depositions_state.dart';
import 'package:flutter_profile/common/models/deposition.dart';
import 'package:flutter_profile/l10n/app_localizations.dart';
import 'package:flutter_profile/screens/DepositionsScreen/components/deposition_add_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDepositionsBloc extends MockBloc<DepositionsEvent, DepositionsState> implements DepositionsBloc {}

Future<MockDepositionsBloc> pumpButton(
  WidgetTester tester, {
  required MockFirebaseAuth auth,
  List<Deposition> depositionsData = const [],
  bool isWritingDeposition = true,
}) async {
  final bloc = MockDepositionsBloc();
  whenListen(bloc, const Stream<DepositionsState>.empty(), initialState: DepositionsInitial());
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<DepositionsBloc>.value(
        value: bloc,
        child: Scaffold(
          body: DepositionAddButton(
            onNewDeposition: () {},
            isWritingDeposition: isWritingDeposition,
            nameTextFocus: FocusNode(),
            depositionTextFocus: FocusNode(),
            depositionsData: depositionsData,
            auth: auth,
          ),
        ),
      ),
    ),
  );
  return bloc;
}

void main() {
  setUpAll(() {
    registerFallbackValue(DepositionsFetchEvent());
  });

  testWidgets('pre-fills the name field with the current user displayName', (tester) async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1', displayName: 'Alexandre'));
    await pumpButton(tester, auth: auth);

    expect(find.widgetWithText(TextFormField, 'Alexandre'), findsOneWidget);
  });

  testWidgets('sends a new deposition with the entered fields when the user has none yet', (tester) async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1', displayName: 'Alexandre'));
    final bloc = await pumpButton(tester, auth: auth, depositionsData: const []);

    await tester.enterText(find.widgetWithText(TextFormField, 'Alexandre'), 'Alex');
    await tester.enterText(find.byType(TextFormField).last, 'Great app!');
    await tester.tap(find.text('Send'));
    await tester.pump();

    final added = verify(() => bloc.add(captureAny())).captured.single as DepositionsAddEvent;
    expect(added.deposition.uid, 'uid1');
    expect(added.deposition.name, 'Alex');
    expect(added.deposition.deposition, 'Great app!');
    expect(added.deposition.isAnonymous, false);
    expect(added.deposition.updatedAt, greaterThan(0));
  });

  testWidgets('falls back to the anonymous label when the name field is cleared and there is no displayName', (tester) async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1', isAnonymous: true, displayName: null));
    final bloc = await pumpButton(tester, auth: auth);

    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.enterText(find.byType(TextFormField).last, 'Great app!');
    await tester.tap(find.text('Send'));
    await tester.pump();

    final added = verify(() => bloc.add(captureAny())).captured.single as DepositionsAddEvent;
    expect(added.deposition.name, 'Anonymous');
    expect(added.deposition.isAnonymous, true);
  });

  testWidgets('shows a confirmation dialog and updates the existing deposition when the user already has one', (tester) async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1', displayName: 'Alexandre'));
    final existing = Deposition(id: 'dep1', uid: 'uid1', name: 'Alexandre', relationship: 0, deposition: 'old text', iconIndex: 0);
    final bloc = await pumpButton(tester, auth: auth, depositionsData: [existing]);

    await tester.enterText(find.byType(TextFormField).last, 'Updated text');
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(find.text('Existing Deposition'), findsOneWidget);

    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    final updated = verify(() => bloc.add(captureAny())).captured.single as DepositionsUpdateEvent;
    expect(updated.deposition.id, 'dep1');
    expect(updated.deposition.deposition, 'Updated text');
    expect(updated.deposition.updatedAt, greaterThan(existing.updatedAt));
  });

  testWidgets('pre-fills the deposition text with the existing content when reopening the panel to edit', (tester) async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: MockUser(uid: 'uid1', displayName: 'Alexandre'));
    final existing = Deposition(id: 'dep1', uid: 'uid1', name: 'Alexandre', relationship: 1, deposition: 'old text', iconIndex: 2);
    final bloc = MockDepositionsBloc();
    whenListen(bloc, const Stream<DepositionsState>.empty(), initialState: DepositionsInitial());
    var isWritingDeposition = false;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<DepositionsBloc>.value(
          value: bloc,
          child: Scaffold(
            body: StatefulBuilder(
              builder:
                  (context, setState) => DepositionAddButton(
                    onNewDeposition: () => setState(() => isWritingDeposition = !isWritingDeposition),
                    isWritingDeposition: isWritingDeposition,
                    nameTextFocus: FocusNode(),
                    depositionTextFocus: FocusNode(),
                    depositionsData: [existing],
                    auth: auth,
                  ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.edit));
    // The pencil icon runs an 8-cycle shake animation (~5.6s) whose timer
    // outlives the tap that swaps it out for the expanded form, so
    // pumpAndSettle() trips the "pending timer" check — pump past its full
    // duration instead, matching profile_skills_list_test's workaround for
    // the analogous unbounded-animation caveat.
    await tester.pump(const Duration(seconds: 6));

    expect(find.widgetWithText(TextFormField, 'old text'), findsOneWidget);
  });
}
