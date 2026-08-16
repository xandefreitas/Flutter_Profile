import 'package:flutter/material.dart';
import '../../common/enums/otp_verification.dart';
import '../../core/core.dart';

import 'components/body/onboarding_completed_body.dart';
import 'components/body/onboarding_phone_body.dart';
import 'components/body/onboarding_welcome_body.dart';

class OnboardingScreen extends StatefulWidget {
  final int initialPage;
  const OnboardingScreen({super.key, this.initialPage = 0});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  int verificationStatusIndex = OTPVerification.INPUTNUMBER.value;

  @override
  void initState() {
    _controller = PageController(initialPage: widget.initialPage);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
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
