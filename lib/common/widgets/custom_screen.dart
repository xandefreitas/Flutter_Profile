import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';

class CustomScreen extends StatelessWidget {
  final Color tabColor;
  final String title;
  final IconData tabIcon;
  final Widget screenBody;
  const CustomScreen({
    Key? key,
    required this.tabColor,
    required this.title,
    required this.tabIcon,
    required this.screenBody,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tabColor.withOpacity(0.8),
                AppColors.white,
                AppColors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 48,
            bottom: 24,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                tabColor.withOpacity(0.8),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                tabIcon,
                size: 40,
                color: AppColors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title.toUpperCase(),
                style: AppTextStyles.textSize24.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        screenBody,
      ],
    );
  }
}
