import 'package:flutter/material.dart';

import '../../core/core.dart';

class CustomSnackBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? snackBarColor;
  const CustomSnackBar({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.snackBarColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(top: 16.0, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: snackBarColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.textBold.copyWith(fontSize: 16),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              icon,
              size: 40,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
