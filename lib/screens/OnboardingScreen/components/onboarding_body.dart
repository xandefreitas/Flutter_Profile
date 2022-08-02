import 'package:flutter/material.dart';
import 'package:flutter_profile/common/enums/otp_verification.dart';

import '../../../core/core.dart';
import '../../NavigationManagementScreen/navigation_management_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingBody extends StatelessWidget {
  final String assetName;
  final String buttonText;
  final Widget pageWidget;
  final Function()? onPressed;
  final bool onboardingLoginScreen;
  final int verificationStatusIndex;
  const OnboardingBody({
    Key? key,
    required this.assetName,
    required this.buttonText,
    required this.pageWidget,
    required this.onPressed,
    required this.onboardingLoginScreen,
    this.verificationStatusIndex = 0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            assetName,
            fit: BoxFit.contain,
          ),
        ),
        pageWidget,
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onboardingLoginScreen && verificationStatusIndex != OTPVerification.INPUTNAME.index)
                  ElevatedButton(
                    child: Text(text.loginAsAnoymousButtonText),
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.white,
                      onPrimary: AppColors.profilePrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      side: const BorderSide(color: AppColors.profilePrimary),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (ctx) => const NavigationManagementScreen()),
                    ),
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: Text(buttonText),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.profilePrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
