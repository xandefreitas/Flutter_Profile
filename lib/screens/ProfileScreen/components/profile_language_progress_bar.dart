import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/core.dart';

class ProfileLanguageProgressBar extends StatefulWidget {
  final int languageLevel;
  final String languageTitle;
  const ProfileLanguageProgressBar({
    Key? key,
    this.languageLevel = 0,
    this.languageTitle = '',
  }) : super(key: key);

  @override
  State<ProfileLanguageProgressBar> createState() => _ProfileLanguageProgressBarState();
}

class _ProfileLanguageProgressBarState extends State<ProfileLanguageProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
            width: (MediaQuery.of(context).size.width * 0.25) * widget.languageLevel,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.profilePrimary.withOpacity(0.2 + 0.2 * widget.languageLevel),
            ),
          ).animate().fadeIn().scaleX(alignment: Alignment.centerLeft, duration: 800.ms, delay: 800.ms * (1 / widget.languageLevel)),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.languageTitle,
              style: AppTextStyles.textWhite,
            ),
          ),
        ],
      ),
    );
  }
}
