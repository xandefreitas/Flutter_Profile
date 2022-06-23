import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_text_styles.dart';

import '../../../core/app_colors.dart';

class DrawerTitle extends StatelessWidget {
  final String title;
  const DrawerTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 32, top: 24),
      padding: const EdgeInsets.only(left: 16),
      height: 40,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        color: AppColors.profilePrimary,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: AppTextStyles.textSize24.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
