import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/custom_icon_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('meets the labeled and Android minimum tap target guidelines', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: CustomIconButton(
            onTap: () {},
            icon: Icons.link,
            iconColor: Colors.black,
            semanticLabel: 'Open LinkedIn profile',
          ),
        ),
      ),
    );

    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    handle.dispose();
  });
}
