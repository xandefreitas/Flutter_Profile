import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class DrawerCustomTitle extends StatelessWidget {
  final String title;
  const DrawerCustomTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 28, top: 24),
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
