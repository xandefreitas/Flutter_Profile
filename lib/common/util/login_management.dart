import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../screens/NavigationManagementScreen/navigation_management_screen.dart';
import '../../screens/OnboardingScreen/onboarding_screen.dart';

class LoginManagement extends StatefulWidget {
  const LoginManagement({super.key});

  @override
  State<LoginManagement> createState() => _LoginManagementState();
}

class _LoginManagementState extends State<LoginManagement> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final Future<bool> _reauthenticateFuture = reauthenticateUser();

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null ||
        (auth.currentUser!.isAnonymous && firstTimeSignIn)) {
      return const OnboardingScreen();
    } else {
      return FutureBuilder<bool>(
        future: _reauthenticateFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppColors.profilePrimary,
                ),
              ),
            );
          }
          if (snapshot.data == false) {
            return const OnboardingScreen();
          }
          return const NavigationManagementScreenContainer();
        },
      );
    }
  }

  Future<bool> reauthenticateUser() async {
    try {
      await auth.currentUser?.reload();
      await auth.currentUser?.getIdToken(true);
      return auth.currentUser != null;
    } catch (e) {
      await auth.signOut();
      return false;
    }
  }

  bool get firstTimeSignIn =>
      auth.currentUser!.metadata.creationTime == DateTime.now();
}
