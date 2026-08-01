import 'package:flutter/material.dart';
import '../../../../common/enums/otp_verification.dart';

import '../../../../core/core.dart';
import 'anonymous_login_button.dart';

class OnboardingBody extends StatelessWidget {
  final String buttonText;
  final Widget pageWidget;
  final Function()? onProceed;
  final bool onboardingLoginScreen;
  final int verificationStatusIndex;
  const OnboardingBody({
    required this.buttonText,
    required this.pageWidget,
    required this.onProceed,
    required this.onboardingLoginScreen,
    super.key,
    this.verificationStatusIndex = 0,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        pageWidget,
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible:
                      onboardingLoginScreen &&
                      verificationStatusIndex !=
                          OTPVerification.INPUTNAME.value,
                  child: const AnonymousLoginButton(),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.profilePrimary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onProceed,
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
