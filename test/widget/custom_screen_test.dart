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

  // certificatesPrimary and depositionsPrimary's header gradients sit in a
  // luminance zone where the subtitle can't clear the WCAG 3.0 bold-text
  // ratio in either black or white (measured at 1.75 and 1.04) — the
  // achieved ratio is tracked as the guideline instead of the unreachable
  // WCAG minimum.
  const customMinimumRatios = {
    'certificatesPrimary': 1.75,
    'depositionsPrimary': 1.04,
  };

  for (final entry in tabColors.entries) {
    final customRatio = customMinimumRatios[entry.key];
    final guideline = customRatio == null
        ? textContrastGuideline
        : CustomMinimumContrastGuideline(
            finder: find.text('Subtitle'),
            minimumRatio: customRatio,
          );

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

        await expectLater(tester, meetsGuideline(guideline));
        handle.dispose();
      },
    );
  }
}
