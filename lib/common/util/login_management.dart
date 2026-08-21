import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../screens/NavigationManagementScreen/navigation_management_screen.dart';
import '../../screens/OnboardingScreen/onboarding_screen.dart';

class LoginManagement extends StatefulWidget {
  final FirebaseAuth? auth;
  const LoginManagement({this.auth, super.key});

  @override
  State<LoginManagement> createState() => _LoginManagementState();
}

class _LoginManagementState extends State<LoginManagement> {
  late final FirebaseAuth auth;
  late final Future<bool> _reauthenticateFuture;

  @override
  void initState() {
    auth = widget.auth ?? FirebaseAuth.instance;
    _reauthenticateFuture = reauthenticateUser(auth);
    super.initState();
  }

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

  bool get firstTimeSignIn =>
      auth.currentUser!.metadata.creationTime == DateTime.now();
}

const _sessionInvalidCodes = {
  'user-disabled',
  'user-not-found',
  'user-token-expired',
  'invalid-user-token',
};

Future<bool> reauthenticateUser(FirebaseAuth auth) async {
  try {
    await auth.currentUser?.reload();
    await auth.currentUser?.getIdToken(true);
    return auth.currentUser != null;
  } on FirebaseAuthException catch (e) {
    if (_sessionInvalidCodes.contains(e.code)) {
      await auth.signOut();
      return false;
    }
    // Not a dead-session error (e.g. offline/timeout) — keep the cached
    // session instead of signing the user out over a network blip.
    return auth.currentUser != null;
  } catch (e) {
    return auth.currentUser != null;
  }
}
