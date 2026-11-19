import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/common/bloc/languageBloc/language_bloc.dart';
import 'package:flutter_profile/common/bloc/languageBloc/language_event.dart';
import 'package:flutter_profile/flutter_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Avoids the app's real routes, which build `LoginManagement` (and thus
/// `FirebaseAuth.instance`) as part of Flutter's default initial-route-stack
/// generation, even for an unrelated route name.
Route<dynamic> noOpRoute(RouteSettings settings) =>
    MaterialPageRoute(builder: (_) => const SizedBox());

Route<dynamic> bottomAlignedRoute(RouteSettings settings) => MaterialPageRoute(
  builder: (_) => Scaffold(
    body: Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(key: const Key('bottom-content'), height: 10),
    ),
  ),
);

void main() {
  testWidgets('keeps route content above the system navigation inset', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    const bottomInset = 24.0;
    const systemGestureInset = 40.0;
    final physicalBottomInset = bottomInset * tester.view.devicePixelRatio;
    final physicalSystemGestureInset =
        systemGestureInset * tester.view.devicePixelRatio;
    tester.view.viewPadding = FakeViewPadding(bottom: physicalBottomInset);
    tester.view.padding = FakeViewPadding(bottom: physicalBottomInset);
    tester.view.systemGestureInsets = FakeViewPadding(
      bottom: physicalSystemGestureInset,
    );
    addTearDown(tester.view.resetViewPadding);
    addTearDown(tester.view.resetPadding);
    addTearDown(tester.view.resetSystemGestureInsets);
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => LanguageBloc(),
        child: FlutterProfile(onGenerateRoute: bottomAlignedRoute),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getBottomLeft(find.byKey(const Key('bottom-content'))).dy,
      tester.view.physicalSize.height / tester.view.devicePixelRatio -
          bottomInset,
    );
  });

  testWidgets(
    'does not apply bottom safe area for Android gesture navigation',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      const bottomInset = 24.0;
      final physicalBottomInset = bottomInset * tester.view.devicePixelRatio;
      tester.view.viewPadding = FakeViewPadding(bottom: physicalBottomInset);
      tester.view.padding = FakeViewPadding(bottom: physicalBottomInset);
      tester.view.systemGestureInsets = FakeViewPadding(
        bottom: physicalBottomInset,
      );
      addTearDown(tester.view.resetViewPadding);
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.view.resetSystemGestureInsets);
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        BlocProvider(
          create: (_) => LanguageBloc(),
          child: FlutterProfile(onGenerateRoute: bottomAlignedRoute),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getBottomLeft(find.byKey(const Key('bottom-content'))).dy,
        tester.view.physicalSize.height / tester.view.devicePixelRatio,
      );
    },
  );

  testWidgets('does not apply safe area on iOS', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    const bottomInset = 24.0;
    final physicalBottomInset = bottomInset * tester.view.devicePixelRatio;
    tester.view.viewPadding = FakeViewPadding(bottom: physicalBottomInset);
    tester.view.padding = FakeViewPadding(bottom: physicalBottomInset);
    addTearDown(tester.view.resetViewPadding);
    addTearDown(tester.view.resetPadding);
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => LanguageBloc(),
        child: FlutterProfile(onGenerateRoute: bottomAlignedRoute),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getBottomLeft(find.byKey(const Key('bottom-content'))).dy,
      tester.view.physicalSize.height / tester.view.devicePixelRatio,
    );
  });

  testWidgets(
    'applies a locale persisted from a previous session once initState finishes loading it',
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
      expect(materialApp.locale, const Locale('pt'));
    },
  );

  testWidgets(
    'LanguageUpdateEvent (e.g. from the language switcher) does update the displayed locale',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final bloc = LanguageBloc();

      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: FlutterProfile(onGenerateRoute: noOpRoute),
        ),
      );
      await tester.pumpAndSettle();

      bloc.add(const LanguageUpdateEvent(locale: Locale('pt')));
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, const Locale('pt'));
    },
  );

  testWidgets(
    'an unrelated Bloc state change (e.g. LanguageFetchEvent) does not disturb the already-applied locale',
    (tester) async {
      SharedPreferences.setMockInitialValues({'language': 'sv'});
      final bloc = LanguageBloc();

      await tester.pumpWidget(
        BlocProvider.value(
          value: bloc,
          child: FlutterProfile(onGenerateRoute: noOpRoute),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
        const Locale('sv'),
      );

      bloc.add(LanguageFetchEvent());
      await tester.pumpAndSettle();

      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).locale,
        const Locale('sv'),
      );
    },
  );
}
