import 'package:flutter/material.dart';
import 'package:flutter_profile/common/enums/work_history_screen_mode.dart';
import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/common/models/occupation.dart';
import 'package:flutter_profile/screens/WorkHistoryScreen/work_history_form_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('shows a validation error and does not call addCompany when the name is empty', (tester) async {
    Company? added;
    await pumpLocalizedApp(
      tester,
      WorkHistoryFormScreen(
        title: 'Add company',
        screenMode: WorkHistoryScreenMode.ADD.value,
        addCompany: (company) => added = company,
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(added, null);
    expect(find.text('Required Field'), findsOneWidget);
  });

  testWidgets('calls addCompany with the filled-in name and any added occupations', (tester) async {
    Company? added;
    await pumpLocalizedApp(
      tester,
      WorkHistoryFormScreen(
        title: 'Add company',
        screenMode: WorkHistoryScreenMode.ADD.value,
        addCompany: (company) => added = company,
      ),
    );

    await tester.enterText(find.widgetWithText(TextFormField, 'Company'), 'Acme');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(added, isNotNull);
    expect(added!.name, 'Acme');
    expect(added!.occupations, isEmpty);
  });

  testWidgets('update mode pre-fills the company name and existing occupations', (tester) async {
    final company = Company(
      id: '1',
      name: 'Acme',
      occupations: [Occupation(role: 'Dev', startDate: DateTime(2020).toIso8601String(), endDate: DateTime(2022).toIso8601String(), description: 'Desc', isCurrentOccupation: false)],
    );

    await pumpLocalizedApp(
      tester,
      WorkHistoryFormScreen(
        title: 'Edit company',
        screenMode: WorkHistoryScreenMode.UPDATE.value,
        company: company,
        updateCompany: (_) {},
        removeCompany: (_) {},
      ),
    );

    expect(find.widgetWithText(TextFormField, 'Acme'), findsOneWidget);
    expect(find.text('Dev'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsWidgets);
  });

  testWidgets('confirming delete invokes removeCompany with the company id', (tester) async {
    String? removedId;
    final company = Company(id: '1', name: 'Acme', occupations: const []);

    await pumpLocalizedApp(
      tester,
      WorkHistoryFormScreen(
        title: 'Edit company',
        screenMode: WorkHistoryScreenMode.UPDATE.value,
        company: company,
        updateCompany: (_) {},
        removeCompany: (id) => removedId = id,
      ),
    );

    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(removedId, '1');
  });
}
