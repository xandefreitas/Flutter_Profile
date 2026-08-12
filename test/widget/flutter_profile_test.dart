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
  testWidgets('applies a locale persisted from a previous session once initState finishes loading it', (tester) async {
    SharedPreferences.setMockInitialValues({'language': 'pt'});

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => LanguageBloc(),
        child: FlutterProfile(onGenerateRoute: noOpRoute),
      ),
    );
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.locale, const Locale('pt'));
  });

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

  testWidgets('an unrelated Bloc state change (e.g. LanguageFetchEvent) does not disturb the already-applied locale', (tester) async {
    SharedPreferences.setMockInitialValues({'language': 'sv'});
    final bloc = LanguageBloc();

    await tester.pumpWidget(
      BlocProvider.value(value: bloc, child: FlutterProfile(onGenerateRoute: noOpRoute)),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).locale, const Locale('sv'));

    bloc.add(LanguageFetchEvent());
    await tester.pumpAndSettle();

    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).locale, const Locale('sv'));
  });
}
