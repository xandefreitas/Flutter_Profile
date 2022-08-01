import 'package:flutter/material.dart';

import 'OnboardingScreen/onboarding_screen.dart';

class LoginManagement extends StatefulWidget {
  const LoginManagement({Key? key}) : super(key: key);

  @override
  State<LoginManagement> createState() => _LoginManagementState();
}

class _LoginManagementState extends State<LoginManagement> {
  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen();
  }
}
