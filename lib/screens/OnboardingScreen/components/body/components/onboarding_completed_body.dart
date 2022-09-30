import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import '../../../../../common/util/app_routes.dart';
import '../../../../../core/core.dart';
import '../onboarding_body.dart';

class OnboardingCompletedBody extends StatelessWidget {
  const OnboardingCompletedBody({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return OnboardingBody(
      buttonText: text.onboardingProceedButtonText,
      pageWidget: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 64.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Lottie.asset('assets/lottie/ready_animation.json'),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    text.onboardingCompleteMessage,
                    style: AppTextStyles.textSize24.copyWith(
                      color: AppColors.profilePrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
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
