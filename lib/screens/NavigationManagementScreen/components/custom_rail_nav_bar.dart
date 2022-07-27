import 'package:flutter/material.dart';
import 'package:flutter_profile/common/enums/nav_bar_items.dart';
import 'package:flutter_profile/core/core.dart';
import 'package:flutter_profile/screens/NavigationManagementScreen/components/animated_rail_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomRailNavBar extends StatelessWidget {
  final Function(int, Color) changeScreen;
  final int index;
  final Color tabActiveColor;
  const CustomRailNavBar({
    Key? key,
    required this.changeScreen,
    required this.index,
    required this.tabActiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tabActiveColor,
        ),
        child: Column(
          children: [
            AnimatedRailButton(
              tabColor: AppColors.profilePrimary,
              title: AppLocalizations.of(context)!.profileTitle,
              iconSelected: Icons.person,
              iconUnselected: Icons.person_outline,
              index: NavBarItems.PROFILE.index,
              isSelected: profileItemSelected,
              changeScreen: changeScreen,
            ),
            const SizedBox(height: 32),
            AnimatedRailButton(
              tabColor: AppColors.certificatesPrimary,
              title: AppLocalizations.of(context)!.certificatesTitle,
              iconSelected: Icons.school,
              iconUnselected: Icons.school_outlined,
              index: NavBarItems.CERTIFICATES.index,
              isSelected: certificatesItemSelected,
              changeScreen: changeScreen,
            ),
            const SizedBox(height: 32),
            AnimatedRailButton(
              tabColor: AppColors.experiencesPrimary,
              title: AppLocalizations.of(context)!.experienceTitle,
              iconSelected: Icons.work,
              iconUnselected: Icons.work_outline,
              index: NavBarItems.EXPERIENCES.index,
              isSelected: experiencesItemSelected,
              changeScreen: changeScreen,
            ),
            const SizedBox(height: 32),
            AnimatedRailButton(
              tabColor: AppColors.depositionsPrimary,
              title: AppLocalizations.of(context)!.depositionsTitle,
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
