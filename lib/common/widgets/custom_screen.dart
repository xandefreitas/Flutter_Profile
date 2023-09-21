import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';

class CustomScreen extends StatefulWidget {
  final Color tabColor;
  final String title;
  final String subtitle;
  final IconData tabIcon;
  final Widget screenBody;
  final bool isAdmin;
  const CustomScreen({
    Key? key,
    required this.tabColor,
    required this.title,
    required this.subtitle,
    required this.tabIcon,
    required this.screenBody,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  State<CustomScreen> createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.tabColor.withOpacity(0.8),
                AppColors.white,
                AppColors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.tabColor.withOpacity(0.8),
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
                  widget.tabIcon,
                  size: 40,
                  color: AppColors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title.toUpperCase(),
                  style: AppTextStyles.textSize24.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: AppTextStyles.textSize16.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
        widget.screenBody,
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
