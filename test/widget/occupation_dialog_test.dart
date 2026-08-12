import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_profile/l10n/app_localizations.dart';
import 'package:flutter_profile/screens/WorkHistoryScreen/components/occupation_dialog.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> openDialog(WidgetTester tester, {required void Function(Occupation) manageOccupation, Occupation? occupation}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => OccupationDialog(primaryColor: Colors.blue, occupation: occupation, manageOccupation: manageOccupation),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('rejects empty and whitespace-only role/description', (tester) async {
    Occupation? saved;
    await openDialog(tester, manageOccupation: (o) => saved = o);

    await tester.enterText(find.widgetWithText(TextFormField, 'Role'), '   ');
    await tester.enterText(find.widgetWithText(TextFormField, 'Description'), '   ');
    await tester.tap(find.text('Add'));
    await tester.pump();

    expect(saved, null);
    expect(find.text('Required Field'), findsNWidgets(2));
  });

  testWidgets('hides the end-date row when marked as current occupation', (tester) async {
    await openDialog(tester, manageOccupation: (_) {});

    expect(find.text('End Date:'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(find.text('End Date:'), findsNothing);
  });

  testWidgets('submitting with current occupation checked forces endDate to empty', (tester) async {
    Occupation? saved;
    await openDialog(tester, manageOccupation: (o) => saved = o);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextFormField, 'Role'), 'Dev');
    await tester.enterText(find.widgetWithText(TextFormField, 'Description'), 'Desc');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(saved, isNotNull);
    expect(saved!.role, 'Dev');
    expect(saved!.isCurrentOccupation, true);
    expect(saved!.endDate, '');
  });

  testWidgets('update mode pre-fills role/description and shows the update title/button', (tester) async {
    final occupation = Occupation(
      role: 'Dev',
      startDate: DateTime(2020).toIso8601String(),
      endDate: DateTime(2022).toIso8601String(),
      description: 'Desc',
      isCurrentOccupation: false,
    );

    await openDialog(tester, occupation: occupation, manageOccupation: (_) {});

    expect(find.widgetWithText(TextFormField, 'Dev'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Desc'), findsOneWidget);
    expect(find.text('Update'), findsOneWidget);
  });
}
