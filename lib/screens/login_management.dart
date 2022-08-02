import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'NavigationManagementScreen/navigation_management_screen.dart';
import 'OnboardingScreen/onboarding_screen.dart';

class LoginManagement extends StatefulWidget {
  const LoginManagement({Key? key}) : super(key: key);

  @override
  State<LoginManagement> createState() => _LoginManagementState();
}

class _LoginManagementState extends State<LoginManagement> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      return const NavigationManagementScreen();
    } else {
      return const OnboardingScreen();
    }
  }
}
