import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../common/api/auth_webclient.dart';
import '../../../../common/util/app_routes.dart';
import '../../../../core/core.dart';

class AnonymousLoginButton extends StatefulWidget {
  const AnonymousLoginButton({
    super.key,
  });

  @override
  State<AnonymousLoginButton> createState() => _AnonymousLoginButtonState();
}

class _AnonymousLoginButtonState extends State<AnonymousLoginButton> {
  bool isSigningInAnonymously = false;

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Visibility(
      visible: !isSigningInAnonymously,
      replacement: Container(
        margin: const EdgeInsets.only(right: 24),
        height: 4,
        width: 80,
        child: const LinearProgressIndicator(
          backgroundColor: Colors.transparent,
          color: AppColors.profilePrimary,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.profilePrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: const BorderSide(color: AppColors.profilePrimary),
        ),
        onPressed: () {
          final auth = FirebaseAuth.instance;
          setState(() {
            isSigningInAnonymously = true;
            AuthWebclient(auth: auth).signInAnonymously().then(
              (value) {
                isSigningInAnonymously = false;
                return Navigator.pushReplacementNamed(context, navigationManagementRoute);
              },
            );
          });
        },
        child: Text(text.loginAsAnonymousButtonText),
      ),
    );
  }
}
