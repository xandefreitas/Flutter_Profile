import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class CustomScreen extends StatefulWidget {
  final Color tabColor;
  final String title;
  final String subtitle;
  final IconData tabIcon;
  final Widget screenBody;
  final bool isAdmin;
  const CustomScreen({
    required this.tabColor,
    required this.title,
    required this.subtitle,
    required this.tabIcon,
    required this.screenBody,
    super.key,
    this.isAdmin = false,
  });

  @override
  State<CustomScreen> createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen>
    with AutomaticKeepAliveClientMixin {
  static const _darkTabLuminanceThreshold = 0.4;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final onTabColor =
        widget.tabColor.computeLuminance() > _darkTabLuminanceThreshold
        ? AppColors.black
        : AppColors.white;
    return Stack(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.tabColor.withValues(alpha: 0.8), AppColors.white],
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
                  widget.tabColor.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(widget.tabIcon, size: 40, color: onTabColor),
                const SizedBox(height: 8),
                Text(
                  widget.title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textSize24.copyWith(
                    color: onTabColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  // Bold, not the original w300: at 16px, bold text only
                  // needs a 3:1 contrast ratio instead of 4.5:1 — without
                  // it, depositionsPrimary's subtitle can't clear the
                  // guideline in either black or white, since its
                  // background sits in the "too medium" luminance zone
                  // for both.
                  style: AppTextStyles.textSize16.copyWith(
                    color: onTabColor,
                    fontWeight: FontWeight.bold,
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
