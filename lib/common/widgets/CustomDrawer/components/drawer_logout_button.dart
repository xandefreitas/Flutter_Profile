import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile/core/core.dart';

import '../../../util/app_routes.dart';

class DrawerLogoutButton extends StatelessWidget {
  const DrawerLogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FirebaseAuth.instance.signOut().then(
              (value) => Navigator.pushReplacementNamed(context, loginManagementRoute),
            );
      },
      child: Row(
        children: [
          const Icon(
            Icons.logout,
            color: AppColors.profilePrimary,
          ),
          const SizedBox(width: 4),
          Text(
            AppLocalizations.of(context)!.drawerLogoutButton,
            style: AppTextStyles.textSize16.copyWith(
              color: AppColors.profilePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
