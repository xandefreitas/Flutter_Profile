import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract class AppTextStyles {
  static const textSemiBold = TextStyle(
    fontWeight: FontWeight.w600,
  );
  static const textMedium = TextStyle(
    fontWeight: FontWeight.w500,
  );
  static const textWhite = TextStyle(
    color: AppColors.white,
  );
  static const textMediumWhite24 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );
  static const textMediumWhite16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );
  static const textNormal12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
  static const textRegular16 = TextStyle(
    fontSize: 16,
  );
}
