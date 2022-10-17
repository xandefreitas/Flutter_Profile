import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile/common/util/app_routes.dart';
import 'package:flutter_profile/common/enums/otp_verification.dart';

import '../../../../common/api/auth_webclient.dart';
import '../../../../core/core.dart';

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
    final text = AppLocalizations.of(context)!;
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
                if (onboardingLoginScreen &&
                    verificationStatusIndex != OTPVerification.INPUTNAME.value)
                  ElevatedButton(
                    child: Text(text.loginAsAnonymousButtonText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.profilePrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      side: const BorderSide(color: AppColors.profilePrimary),
                    ),
                    onPressed: () {
                      final auth = FirebaseAuth.instance;
                      AuthWebclient(auth: auth).signInAnonymously().then(
                            (value) => Navigator.pushReplacementNamed(
                                context, navigationManagementRoute),
                          );
                    },
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: Text(buttonText),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.profilePrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: onProceed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
