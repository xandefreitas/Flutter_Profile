import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class CustomSnackBarBody extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? snackBarColor;
  const CustomSnackBarBody({
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 2,
          color: AppColors.white,
        ),
        color: snackBarColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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
            padding: const EdgeInsets.only(left: 8.0),
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
