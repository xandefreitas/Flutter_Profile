// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';

enum NavBarItems { PROFILE, CERTIFICATES, EXPERIENCES, DEPOSITIONS }

extension NavBarItemsExtension on NavBarItems {
  int get index {
    switch (this) {
      case NavBarItems.PROFILE:
        return 0;
      case NavBarItems.CERTIFICATES:
        return 1;
      case NavBarItems.EXPERIENCES:
        return 2;
      case NavBarItems.DEPOSITIONS:
        return 3;
      default:
        return 0;
    }
  }

  Color get color {
    switch (this) {
      case NavBarItems.PROFILE:
        return AppColors.profilePrimary;
      case NavBarItems.CERTIFICATES:
        return AppColors.certificatesPrimary;
      case NavBarItems.EXPERIENCES:
        return AppColors.experiencesPrimary;
      case NavBarItems.DEPOSITIONS:
        return AppColors.depositionsPrimary;
      default:
        return AppColors.profilePrimary;
    }
  }
}
