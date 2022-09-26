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
    final text = AppLocalizations.of(context)!;
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
              title: text.profileTitle,
              iconSelected: Icons.person,
              iconUnselected: Icons.person_outline,
              index: NavBarItems.PROFILE.value,
              isSelected: profileItemSelected,
              changeScreen: changeScreen,
            ),
            const SizedBox(height: 32),
            AnimatedRailButton(
              tabColor: AppColors.certificatesPrimary,
              title: text.certificatesTitle,
              iconSelected: Icons.school,
              iconUnselected: Icons.school_outlined,
              index: NavBarItems.CERTIFICATES.value,
              isSelected: certificatesItemSelected,
              changeScreen: changeScreen,
            ),
            const SizedBox(height: 32),
            AnimatedRailButton(
              tabColor: AppColors.workHistoryPrimary,
              title: text.workHistoryTitle,
              iconSelected: Icons.work,
              iconUnselected: Icons.work_outline,
              index: NavBarItems.WORKHISTORY.value,
              isSelected: workHistoryItemSelected,
              changeScreen: changeScreen,
            ),
            const SizedBox(height: 32),
            AnimatedRailButton(
              tabColor: AppColors.depositionsPrimary,
              title: text.depositionsTitle,
              iconSelected: Icons.comment,
              iconUnselected: Icons.comment_outlined,
              index: NavBarItems.DEPOSITIONS.value,
              isSelected: depositionsItemSelected,
              changeScreen: changeScreen,
            ),
          ],
        ),
      ),
    );
  }

  bool get profileItemSelected => index == NavBarItems.PROFILE.value;
  bool get certificatesItemSelected => index == NavBarItems.CERTIFICATES.value;
  bool get workHistoryItemSelected => index == NavBarItems.WORKHISTORY.value;
  bool get depositionsItemSelected => index == NavBarItems.DEPOSITIONS.value;
}
