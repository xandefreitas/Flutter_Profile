import 'package:flutter/material.dart';
import 'package:flutter_profile/common/enums/otp_verification.dart';
import 'package:flutter_profile/core/core.dart';
import 'package:flutter_profile/screens/OnboardingScreen/components/body/components/onboarding_completed_body.dart';
import 'package:flutter_profile/screens/OnboardingScreen/components/body/components/onboarding_phone_body.dart';
import 'package:flutter_profile/screens/OnboardingScreen/components/body/components/onboarding_welcome_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  final int initialPage;
  const OnboardingScreen({Key? key, this.initialPage = 0}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late AppLocalizations text;
  late PageController _controller;
  int verificationStatusIndex = OTPVerification.INPUTNUMBER.value;
  @override
  void initState() {
    _controller = PageController(initialPage: widget.initialPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: PageView(
        // physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          OnboardingWelcomeBody(controller: _controller),
          OnboardingPhoneBody(controller: _controller),
          const OnboardingCompletedBody(),
        ],
      ),
    );
  }
}
