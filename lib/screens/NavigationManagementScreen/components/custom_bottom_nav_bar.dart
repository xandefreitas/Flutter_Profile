import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/screens/NavigationManagementScreen/components/animated_button.dart';

import '../../../common/enums/nav_bar_items.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Function(NavBarIcons, Color) changeScreen;
  final NavBarIcons navBarIcons;
  final Color tabActiveColor;
  const CustomBottomNavBar({
    Key? key,
    required this.changeScreen,
    required this.navBarIcons,
    required this.tabActiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tabActiveColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedButton(
              tabColor: AppColors.profilePrimary,
              title: 'Perfil',
              iconSelected: Icons.person,
              iconUnselected: Icons.person_outline,
              navBarIcons: NavBarIcons.PROFILE,
              isSelected: navBarIcons == NavBarIcons.PROFILE,
              changeScreen: changeScreen,
            ),
            AnimatedButton(
              tabColor: AppColors.certificatesPrimary,
              title: 'Certificados',
              iconSelected: Icons.school,
              iconUnselected: Icons.school_outlined,
              navBarIcons: NavBarIcons.CERTIFICATES,
              isSelected: navBarIcons == NavBarIcons.CERTIFICATES,
              changeScreen: changeScreen,
            ),
            AnimatedButton(
              tabColor: AppColors.experiencesPrimary,
              title: 'Experiência',
              iconSelected: Icons.work,
              iconUnselected: Icons.work_outline,
              navBarIcons: NavBarIcons.EXPERIENCES,
              isSelected: navBarIcons == NavBarIcons.EXPERIENCES,
              changeScreen: changeScreen,
            ),
            AnimatedButton(
              tabColor: AppColors.depositionsPrimary,
              title: 'Depoimentos',
              iconSelected: Icons.comment,
              iconUnselected: Icons.comment_outlined,
              navBarIcons: NavBarIcons.DEPOSITIONS,
              isSelected: navBarIcons == NavBarIcons.DEPOSITIONS,
              changeScreen: changeScreen,
            ),
          ],
        ),
      ),
    );
  }
}
