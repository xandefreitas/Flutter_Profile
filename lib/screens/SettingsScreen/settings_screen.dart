import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hello there, the data you see bellow is the only info we have about your user.',
              ),
              Text(
                'Display Name: ${FirebaseAuth.instance.currentUser?.displayName ?? ''}',
              ),
              Text(
                'Phone Number: ${FirebaseAuth.instance.currentUser?.phoneNumber ?? ''}',
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
                child: Text('Delete Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
