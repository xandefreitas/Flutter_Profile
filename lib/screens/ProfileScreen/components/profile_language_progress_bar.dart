import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../common/util/analytics_util.dart';
import '../../../common/util/motion_util.dart';
import '../../../core/core.dart';

class ProfileLanguageProgressBar extends StatefulWidget {
  final int languageLevel;
  final String languageTitle;
  final String languageDescription;
  const ProfileLanguageProgressBar({
    required this.languageDescription,
    super.key,
    this.languageLevel = 0,
    this.languageTitle = '',
  });

  @override
  State<ProfileLanguageProgressBar> createState() =>
      _ProfileLanguageProgressBarState();
}

class _ProfileLanguageProgressBarState
    extends State<ProfileLanguageProgressBar> {
  final GlobalKey<TooltipState> _tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    final content = Tooltip(
      key: _tooltipKey,
      message: widget.languageDescription,
      preferBelow: false,
      triggerMode: TooltipTriggerMode.manual,
      onTriggered: () =>
          AnalyticsUtil.logLanguageBarTooltipOpened(widget.languageTitle),
      showDuration: const Duration(seconds: 20),
      decoration: BoxDecoration(
        color: AppColors.profilePrimary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              HapticFeedback.selectionClick();
              _tooltipKey.currentState?.ensureTooltipVisible();
            },
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Container(
                  height: 28,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.lightGrey,
                  ),
                ),
                Container(
                  height: 28,
                  width:
                      (MediaQuery.sizeOf(context).width * 0.25) *
                      widget.languageLevel,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.profilePrimary.withValues(
                      alpha: 0.6 + 0.1 * widget.languageLevel,
                    ),
                  ),
                ).animate().fadeIn().scaleX(
                  alignment: Alignment.centerLeft,
                  duration: 800.ms,
                  delay: widget.languageLevel == 0
                      ? Duration.zero
                      : 800.ms * (1 / widget.languageLevel),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 24.0),
                  child: Text(
                    widget.languageTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textWhite,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.info_outline,
                      size: 18,
                      color: widget.languageLevel == 4
                          ? AppColors.white
                          : AppColors.profilePrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return MotionUtil.reduceMotion(context)
        ? content
        : content.animate().scaleXY(
            begin: 0.9,
            end: 1,
            duration: 350.ms,
            curve: Curves.easeOutBack,
          );
  }
}
