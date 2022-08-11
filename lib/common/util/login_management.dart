import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/NavigationManagementScreen/navigation_management_screen.dart';
import '../../screens/OnboardingScreen/onboarding_screen.dart';

class LoginManagement extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  LoginManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      return const NavigationManagementScreen();
    } else {
      return const OnboardingScreen();
    }
  }
}
