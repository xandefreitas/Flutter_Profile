import 'package:flutter/material.dart';
import 'package:flutter_profile/common/util/app_routes.dart';
import 'package:flutter_profile/common/enums/otp_verification.dart';
import 'package:flutter_profile/core/core.dart';
import '../../common/widgets/language_widget.dart';
import 'components/onboarding_body.dart';
import '../../common/widgets/custom_onboarding_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  final int initialPage;
  const OnboardingScreen({Key? key, this.initialPage = 0}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  late AppLocalizations text;
  late PageController _controller;
  late int _currentPage;
  int verificationStatusIndex = OTPVerification.INPUTNUMBER.value;
  @override
  void initState() {
    _controller = PageController(initialPage: widget.initialPage);
    _currentPage = widget.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: PageView(
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          firstOnboardingScreen(),
          secondOnboardingScreen(),
          thirdOnboardingScreen(context),
        ],
      ),
    );
  }

  OnboardingBody thirdOnboardingScreen(BuildContext context) {
    return OnboardingBody(
      assetName: 'assets/images/onboarding_03.png',
      buttonText: text.onboardingProceedButtonText,
      pageWidget: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120.0),
          child: Text(
            text.onboardingCompleteMessage,
            style: AppTextStyles.textSize24.copyWith(
              color: AppColors.profilePrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onboardingLoginScreen: onboardingLoginScreen,
      onProceed: () {
        Navigator.pushReplacementNamed(context, navigationManagementRoute);
      },
    );
  }

  OnboardingBody secondOnboardingScreen() {
    return OnboardingBody(
      assetName: 'assets/images/onboarding_02.png',
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
              CustomOnboardingForm(
                formKey: _formKey,
                verificationStatusIndex: verificationStatusIndex,
                nextVerificationStatusIndex: nextVerificationStatusIndex,
                firstVerificationStatusIndex: firstVerificationStatusIndex,
              ),
            ],
          ),
        ),
      ),
      onboardingLoginScreen: onboardingLoginScreen,
      onProceed: verificationStatusIndex != OTPVerification.INPUTNAME.value
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
              }
            },
    );
  }

  OnboardingBody firstOnboardingScreen() {
    return OnboardingBody(
      assetName: 'assets/images/onboarding_01.png',
      buttonText: text.onboardingNextButtonText,
      pageWidget: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text.onboardingWelcomeMessage,
                  style: AppTextStyles.textSize24.copyWith(
                    color: AppColors.profilePrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
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
      onboardingLoginScreen: onboardingLoginScreen,
      onProceed: () {
        _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
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

  bool get onboardingLoginScreen => _currentPage == 1;
}
