import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
  static const textMedium = TextStyle(
    fontWeight: FontWeight.w500,
  );
  static const textSemiBold = TextStyle(
    fontWeight: FontWeight.w600,
  );
  static const textBold = TextStyle(
    fontWeight: FontWeight.bold,
  );
  static const textWhite = TextStyle(
    color: AppColors.white,
  );
  static const textProfilePrimary = TextStyle(
    color: AppColors.profilePrimary,
  );
  static const textSize12 = TextStyle(
    fontSize: 12,
  );
  static const textSize16 = TextStyle(
    fontSize: 16,
  );
  static const textSize24 = TextStyle(
    fontSize: 24,
  );
}
