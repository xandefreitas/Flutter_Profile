import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class DrawerCustomTextButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final Widget? leading;
  const DrawerCustomTextButton({super.key, required this.title, required this.onTap, this.leading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading ?? const SizedBox(),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.textSize16.copyWith(
                  color: AppColors.profilePrimary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
