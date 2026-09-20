import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/custom_screen.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tabColors = {
    'certificatesPrimary': AppColors.certificatesPrimary,
    'workHistoryPrimary': AppColors.workHistoryPrimary,
    'depositionsPrimary': AppColors.depositionsPrimary,
    'profilePrimary': AppColors.profilePrimary,
  };

  for (final entry in tabColors.entries) {
    testWidgets(
      'meets the minimum text contrast guideline for the ${entry.key} header',
      (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          MaterialApp(
            home: CustomScreen(
              tabColor: entry.value,
              title: 'Title',
              subtitle: 'Subtitle',
              tabIcon: Icons.school,
              screenBody: const SizedBox.shrink(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
      },
    );
  }
}
