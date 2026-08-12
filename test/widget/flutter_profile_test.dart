import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/bloc/languageBloc/language_bloc.dart';
import 'package:flutter_profile/common/bloc/languageBloc/language_event.dart';
import 'package:flutter_profile/flutter_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Avoids the app's real routes, which build `LoginManagement` (and thus
/// `FirebaseAuth.instance`) as part of Flutter's default initial-route-stack
/// generation, even for an unrelated route name.
Route<dynamic> noOpRoute(RouteSettings settings) => MaterialPageRoute(builder: (_) => const SizedBox());

void main() {
  testWidgets(
    'BUG: a locale persisted from a previous session is fetched in initState but never applied, '
    'because the completed Future mutates _locale without calling setState',
    (tester) async {
      SharedPreferences.setMockInitialValues({'language': 'pt'});

      await tester.pumpWidget(
        BlocProvider(
          create: (_) => LanguageBloc(),
          child: FlutterProfile(onGenerateRoute: noOpRoute),
        ),
      );
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, const Locale('en'));
    },
  );

  testWidgets('LanguageUpdateEvent (e.g. from the language switcher) does update the displayed locale', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final bloc = LanguageBloc();

    await tester.pumpWidget(
      BlocProvider.value(value: bloc, child: FlutterProfile(onGenerateRoute: noOpRoute)),
    );
    await tester.pumpAndSettle();

    bloc.add(const LanguageUpdateEvent(locale: Locale('pt')));
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.locale, const Locale('pt'));
  });

  testWidgets(
    'BUG: the persisted locale only ends up displayed by accident — any unrelated Bloc state change '
    '(here, an ordinary LanguageFetchEvent that the listener does not even branch on for '
    'LanguageFetchedState) forces a rebuild that happens to pick up the _locale field already mutated '
    'silently in initState, rather than the locale being applied deterministically once loaded',
    (tester) async {
      SharedPreferences.setMockInitialValues({'language': 'sv'});
      final bloc = LanguageBloc();

      await tester.pumpWidget(
        BlocProvider.value(value: bloc, child: FlutterProfile(onGenerateRoute: noOpRoute)),
      );
      await tester.pumpAndSettle();

      // Before any further rebuild, the persisted locale is not yet shown —
      // this is the same bug pinned above.
      expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).locale, const Locale('en'));

      // Dispatching a state change unrelated to locale updates (a plain
      // re-fetch) still forces BlocConsumer's builder to rerun, which
      // incidentally reads the already-mutated _locale field.
      bloc.add(LanguageFetchEvent());
      await tester.pumpAndSettle();

      expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).locale, const Locale('sv'));
    },
  );
}
