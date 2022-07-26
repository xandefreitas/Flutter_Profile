import 'package:flutter/material.dart';
import 'package:flutter_profile/core/core.dart';
import '../../common/widgets/language_widget.dart';
import '../NavigationManagementScreen/navigation_management_screen.dart';
import 'components/onboarding_body.dart';
import '../../common/widgets/custom_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController(initialPage: 0);
  final _formKey = GlobalKey<FormState>();

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: PageView(
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        // physics: const NeverScrollableScrollPhysics(),
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
      buttonText: 'Entrar',
      pageWidget: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 120.0),
          child: Text(
            'Tudo pronto!\nAgora vamos ao aplicativo!',
            style: AppTextStyles.textSize24.copyWith(
              color: AppColors.profilePrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onboardingLoginScreen: onboardingLoginScreen,
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationManagementScreen(),
          ),
        );
      },
    );
  }

  OnboardingBody secondOnboardingScreen() {
    return OnboardingBody(
      assetName: 'assets/images/onboarding_02.png',
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
                AppLocalizations.of(context)!.loginMessage,
                style: AppTextStyles.textSize24.copyWith(
                  color: AppColors.profilePrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              CustomForm(formKey: _formKey),
            ],
          ),
        ),
      ),
      onboardingLoginScreen: onboardingLoginScreen,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
        }
      },
    );
  }

  OnboardingBody firstOnboardingScreen() {
    return OnboardingBody(
      assetName: 'assets/images/onboarding_01.png',
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
                  AppLocalizations.of(context)!.welcomeMessage,
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
      onPressed: () {
        _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      },
    );
  }

  bool get onboardingLoginScreen => _currentPage == 1;

  // showCustomSnackBar(BuildContext context, String title, String subtitle, IconData icon, Color? snackBarColor) {
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(
  //         SnackBar(
  //           behavior: SnackBarBehavior.floating,
  //           backgroundColor: Colors.transparent,
  //           elevation: 0,
  //           content: CustomSnackBar(
  //             title: title,
  //             subtitle: subtitle,
  //             icon: icon,
  //             snackBarColor: snackBarColor,
  //           ),
  //           duration: const Duration(seconds: 10),
  //         ),
  //       )
  //       .closed
  //       .then((value) => setState(() => snackBarIsClosed = !snackBarIsClosed));
  // }
}
