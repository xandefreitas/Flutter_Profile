// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';

enum NavBarItems {
  PROFILE(0, AppColors.profilePrimary),
  CERTIFICATES(1, AppColors.certificatesPrimary),
  WORKHISTORY(2, AppColors.workHistoryPrimary),
  DEPOSITIONS(3, AppColors.depositionsPrimary);

  final int value;
  final Color color;
  const NavBarItems(this.value, this.color);
}
