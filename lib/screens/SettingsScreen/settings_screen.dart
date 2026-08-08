import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(text.settingsInfoMessage),
              Text(
                text.settingsDisplayNameLabel(
                  FirebaseAuth.instance.currentUser?.displayName ?? '',
                ),
              ),
              Text(
                text.settingsPhoneNumberLabel(
                  FirebaseAuth.instance.currentUser?.phoneNumber ?? '',
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                    (_) => AppColors.snackBarError,
                  ),
                  foregroundColor: WidgetStateColor.resolveWith(
                    (_) => AppColors.white,
                  ),
                ),
                child: Text(text.settingsDeleteAccountButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
