import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../common/widgets/language_widget.dart';
import '../../../../../core/core.dart';
import '../onboarding_body.dart';

class OnboardingWelcomeBody extends StatelessWidget {
  final PageController controller;
  const OnboardingWelcomeBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return OnboardingBody(
      assetName: 'assets/lottie/mobile_developer.json',
      buttonText: text.onboardingNextButtonText,
      pageWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 120.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  text.onboardingWelcomeMessage,
                  style: AppTextStyles.textSize24.copyWith(
                    color: AppColors.profilePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.profilePrimary),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.white,
                  ),
                  child: const LanguageWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
      onboardingLoginScreen: false,
      onProceed: () {
        controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      },
    );
  }
}
