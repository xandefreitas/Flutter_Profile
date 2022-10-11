import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../../common/widgets/language_widget.dart';
import '../../../../../core/core.dart';
import 'onboarding_body.dart';

class OnboardingWelcomeBody extends StatelessWidget {
  final PageController controller;
  const OnboardingWelcomeBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return OnboardingBody(
      buttonText: text.onboardingNextButtonText,
      pageWidget: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 280,
          child: Padding(
            padding: const EdgeInsets.only(top: 64.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset('assets/lottie/welcome_animation.json'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      text.onboardingWelcomeMessage,
                      style: AppTextStyles.textSize24.copyWith(
                        color: AppColors.profilePrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
      ),
      onboardingLoginScreen: false,
      onProceed: () {
        controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      },
    );
  }
}
