import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../common/util/app_routes.dart';
import '../../../../../core/core.dart';
import '../onboarding_body.dart';

class OnboardingCompletedBody extends StatelessWidget {
  const OnboardingCompletedBody({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return OnboardingBody(
      assetName: 'assets/lottie/opening_animation.json',
      buttonText: text.onboardingProceedButtonText,
      pageWidget: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120.0),
          child: Text(
            text.onboardingCompleteMessage,
            style: AppTextStyles.textSize24.copyWith(
              color: AppColors.profilePrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onboardingLoginScreen: false,
      onProceed: () {
        Navigator.pushReplacementNamed(context, navigationManagementRoute);
      },
    );
  }
}
