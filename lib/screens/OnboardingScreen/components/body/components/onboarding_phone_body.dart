import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../common/enums/otp_verification.dart';
import '../../../../../core/core.dart';
import '../../onboarding_form.dart';
import '../onboarding_body.dart';

class OnboardingPhoneBody extends StatefulWidget {
  final PageController controller;
  const OnboardingPhoneBody({super.key, required this.controller});

  @override
  State<OnboardingPhoneBody> createState() => _OnboardingPhoneBodyState();
}

class _OnboardingPhoneBodyState extends State<OnboardingPhoneBody> {
  final _formKey = GlobalKey<FormState>();
  int verificationStatusIndex = OTPVerification.INPUTNUMBER.value;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return OnboardingBody(
      assetName: 'assets/lottie/opening_animation.json',
      buttonText: text.onboardingNextButtonText,
      verificationStatusIndex: verificationStatusIndex,
      pageWidget: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 80.0,
            left: 32,
            right: 32,
          ),
          child: Column(
            children: [
              Text(
                verificationStatusIndex == 2 ? text.onboardingEnterNameMessage : text.onboardingLoginMessage,
                style: AppTextStyles.textSize24.copyWith(
                  color: AppColors.profilePrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OnboardingForm(
                formKey: _formKey,
                verificationStatusIndex: verificationStatusIndex,
                nextVerificationStatusIndex: nextVerificationStatusIndex,
                firstVerificationStatusIndex: firstVerificationStatusIndex,
              ),
            ],
          ),
        ),
      ),
      onboardingLoginScreen: true,
      onProceed: verificationStatusIndex != OTPVerification.INPUTNAME.value
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                widget.controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
    );
  }

  nextVerificationStatusIndex() {
    setState(() {
      verificationStatusIndex += 1;
    });
  }

  firstVerificationStatusIndex() {
    setState(() {
      if (verificationStatusIndex != 0) verificationStatusIndex = 0;
    });
  }
}
