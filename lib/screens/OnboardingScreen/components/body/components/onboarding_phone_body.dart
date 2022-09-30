import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

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
      buttonText: text.onboardingNextButtonText,
      verificationStatusIndex: verificationStatusIndex,
      pageWidget: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 64,
            left: 32,
            right: 32,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Lottie.asset('assets/lottie/phone_animation.json', width: MediaQuery.of(context).size.width * 0.6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    verificationStatusIndex == 2 ? text.onboardingEnterNameMessage : text.onboardingLoginMessage,
                    style: AppTextStyles.textSize24.copyWith(
                      color: AppColors.profilePrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
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
