import 'package:flutter/material.dart';
import 'package:flutter_profile/common/util/relationship_util.dart';
import 'package:flutter_profile/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<BuildContext> pumpContext(WidgetTester tester) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox();
          },
        ),
      ),
    );
    return capturedContext;
  }

  testWidgets('maps relationship codes 0-5 to the correct localized string', (tester) async {
    final context = await pumpContext(tester);
    final text = AppLocalizations.of(context)!;

    expect(RelationshipUtil.getRelationshipName(context: context, relationshipCode: 0), text.relationshipDataFriend);
    expect(RelationshipUtil.getRelationshipName(context: context, relationshipCode: 1), text.relationshipDataCoworker);
    expect(RelationshipUtil.getRelationshipName(context: context, relationshipCode: 2), text.relationshipDataBoss);
    expect(RelationshipUtil.getRelationshipName(context: context, relationshipCode: 3), text.relationshipDataClient);
    expect(RelationshipUtil.getRelationshipName(context: context, relationshipCode: 4), text.relationshipDataFamily);
    expect(RelationshipUtil.getRelationshipName(context: context, relationshipCode: 5), text.relationshipDataRecruiter);
  });

  testWidgets('falls back to the friend label for an out-of-range code', (tester) async {
    final context = await pumpContext(tester);
    final text = AppLocalizations.of(context)!;

    expect(RelationshipUtil.getRelationshipName(context: context, relationshipCode: 99), text.relationshipDataFriend);
  });

  testWidgets('defaults to the friend label when no code is given', (tester) async {
    final context = await pumpContext(tester);
    final text = AppLocalizations.of(context)!;

    expect(RelationshipUtil.getRelationshipName(context: context), text.relationshipDataFriend);
  });
}
