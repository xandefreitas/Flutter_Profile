import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/screens/NavigationManagementScreen/components/animated_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../common/enums/nav_bar_items.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(int, Color) changeScreen;
  final int index;
  final Color tabActiveColor;
  const CustomBottomNavBar({
    Key? key,
    required this.changeScreen,
    required this.index,
    required this.tabActiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: tabActiveColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedButton(
              tabColor: AppColors.profilePrimary,
              title: text.profileTitle,
              iconSelected: Icons.person,
              iconUnselected: Icons.person_outline,
              index: NavBarItems.PROFILE.index,
              isSelected: profileItemSelected,
              changeScreen: changeScreen,
            ),
            AnimatedButton(
              tabColor: AppColors.certificatesPrimary,
              title: text.certificatesTitle,
              iconSelected: Icons.school,
              iconUnselected: Icons.school_outlined,
              index: NavBarItems.CERTIFICATES.index,
              isSelected: certificatesItemSelected,
              changeScreen: changeScreen,
            ),
            AnimatedButton(
              tabColor: AppColors.experiencesPrimary,
              title: text.experienceTitle,
              iconSelected: Icons.work,
              iconUnselected: Icons.work_outline,
              index: NavBarItems.EXPERIENCES.index,
              isSelected: experiencesItemSelected,
              changeScreen: changeScreen,
            ),
            AnimatedButton(
              tabColor: AppColors.depositionsPrimary,
              title: text.depositionsTitle,
              iconSelected: Icons.comment,
              iconUnselected: Icons.comment_outlined,
              index: NavBarItems.DEPOSITIONS.index,
              isSelected: depositionsItemSelected,
              changeScreen: changeScreen,
            ),
          ],
        ),
      ),
    );
  }

  bool get profileItemSelected => index == NavBarItems.PROFILE.index;
  bool get certificatesItemSelected => index == NavBarItems.CERTIFICATES.index;
  bool get experiencesItemSelected => index == NavBarItems.EXPERIENCES.index;
  bool get depositionsItemSelected => index == NavBarItems.DEPOSITIONS.index;
}
