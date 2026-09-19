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
  // The header sits on a gradient from widget.tabColor to transparent/white,
  // so white text contrast against it varies by tab color and by how far
  // down the gradient the text falls — a shadow keeps it legible without
  // having to pick a different color per tab.
  static const _headerTextShadows = [
    Shadow(color: Colors.black45, blurRadius: 2),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                Icon(widget.tabIcon, size: 40, color: AppColors.white),
                const SizedBox(height: 8),
                Text(
                  widget.title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textSize24.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    shadows: _headerTextShadows,
                  ),
                ),
                Text(
                  widget.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textSize16.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w300,
                    shadows: _headerTextShadows,
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
