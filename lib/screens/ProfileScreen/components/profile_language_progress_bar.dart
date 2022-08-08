import 'package:flutter/material.dart';

import '../../../core/core.dart';

class ProfileLanguageProgressBar extends StatefulWidget {
  final int languageLevel;
  final String languageTitle;
  final bool languageBarisVisible;
  const ProfileLanguageProgressBar({
    Key? key,
    this.languageLevel = 0,
    this.languageTitle = '',
    this.languageBarisVisible = false,
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
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: 28,
            width: widget.languageBarisVisible ? (MediaQuery.of(context).size.width * 0.25) * widget.languageLevel : 0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.profilePrimary.withOpacity(0.2 + 0.2 * widget.languageLevel),
            ),
          ),
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
