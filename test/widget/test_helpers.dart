import 'package:flutter/material.dart';
import 'package:flutter_profile/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps [child] in a [MaterialApp] with localization delegates configured,
/// since every screen reads `AppLocalizations.of(context)!`.
Future<void> pumpLocalizedApp(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}
