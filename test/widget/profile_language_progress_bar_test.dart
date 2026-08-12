import 'package:flutter/material.dart';
import 'package:flutter_profile/screens/ProfileScreen/components/profile_language_progress_bar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the language title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Material(
          child: ProfileLanguageProgressBar(languageTitle: 'English', languageLevel: 3),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.byType(Tooltip), findsNothing);
  });

  testWidgets('wraps in a Tooltip when languageDescription is provided', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Material(
          child: ProfileLanguageProgressBar(languageTitle: 'English', languageLevel: 3, languageDescription: 'Fluent'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Tooltip), findsOneWidget);
    expect(tester.widget<Tooltip>(find.byType(Tooltip)).message, 'Fluent');
  });

  testWidgets(
    'BUG: the default languageLevel of 0 crashes the animation delay calculation '
    '(800.ms * (1 / 0) is an infinite Duration, and Duration.round() throws on infinity)',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Material(
            child: ProfileLanguageProgressBar(languageTitle: 'English'),
          ),
        ),
      );

      expect(tester.takeException(), isA<UnsupportedError>());
    },
  );
}
