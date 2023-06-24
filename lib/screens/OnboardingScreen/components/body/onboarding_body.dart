import 'package:flutter/material.dart';
import 'package:flutter_profile/common/enums/otp_verification.dart';

import '../../../../core/core.dart';
import 'anonymous_login_button.dart';

class OnboardingBody extends StatelessWidget {
  final String buttonText;
  final Widget pageWidget;
  final Function()? onProceed;
  final bool onboardingLoginScreen;
  final int verificationStatusIndex;
  const OnboardingBody({
    Key? key,
    required this.buttonText,
    required this.pageWidget,
    required this.onProceed,
    required this.onboardingLoginScreen,
    this.verificationStatusIndex = 0,
  }) : super(key: key);
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
                  visible: onboardingLoginScreen && verificationStatusIndex != OTPVerification.INPUTNAME.value,
                  child: const AnonymousLoginButton(),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.profilePrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
